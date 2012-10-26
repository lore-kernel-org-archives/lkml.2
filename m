Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966049Ab2JZSlk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 14:41:40 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:42678 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966020Ab2JZSlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 14:41:39 -0400
MIME-Version: 1.0
In-Reply-To: <508AD2FF.5020306@redhat.com>
References: <20121025121617.617683848@chello.nl> <20121025124832.840241082@chello.nl>
 <CA+55aFxRh43832cEW39t0+d1Sdz46Up6Za9w641jpWukmi4zFw@mail.gmail.com>
 <5089F5B5.1050206@redhat.com> <CA+55aFwcj=nh1RUmEXUk6W3XwfbdQdQofkkCstbLGVo1EoKryA@mail.gmail.com>
 <508A0A0D.4090001@redhat.com> <CA+55aFx2fSdDcFxYmu00JP9rHiZ1BjH3tO4CfYXOhf_rjRP_Eg@mail.gmail.com>
 <CANN689EHj2inp+wjJGcqMHZQUV3Xm+3dAkLPOsnV4RZU+Kq5nA@mail.gmail.com>
 <CA+55aFwpZ5pO2G7gs3Pga5et1DQZ4qMoe1CLFkSrVQK_4K4rhA@mail.gmail.com>
 <508ACE6E.8060303@redhat.com> <CA+55aFyYvu20qHtJ2SuNK3Dd466Hs9m9U3_41E8HtQ6KiRVRKw@mail.gmail.com>
 <508AD2FF.5020306@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 26 Oct 2012 11:41:17 -0700
X-Google-Sender-Auth: PQ8SoJD-nIXSkHZnGbk81N2IOcg
Message-ID: <CA+55aFy7LvPP+DAENWftMpL=H_M5Pn9mVCHiEP7YVbFHcmbVbQ@mail.gmail.com>
Subject: Re: [PATCH 05/31] x86/mm: Reduce tlb flushes from ptep_set_access_flags()
To: Rik van Riel <riel@redhat.com>
Cc: Michel Lespinasse <walken@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 11:14 AM, Rik van Riel <riel@redhat.com> wrote:
>
> I suspect the next context switch would flush out the TLB,
> making it a slowdown, not a lockup.

Common case, yes. But the page fault might happen in kernel space (due
to a "put_user()" call, say), and with CONFIG_PREEMPT=n.

Sure, put_user() is always done in a context where blocking (and
scheduling) is legal, but that doesn't necessarily equate scheduling
actually happening. If we're returning to kernel space and don't have
any IO, it might never happen.

Anyway, I suspect such behavior it's almost impossible to trigger.
Which would just make it rather hard to find.

             Linus
