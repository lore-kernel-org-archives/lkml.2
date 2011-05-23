Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853Ab1EWQIC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 12:08:02 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39579 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752223Ab1EWQIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 12:08:00 -0400
MIME-Version: 1.0
In-Reply-To: <20110523090918.GA5474@elte.hu>
References: <20110520161210.81bbef3a.sfr@canb.auug.org.au> <BANLkTi=Dn_jvJ8mLY0Bc6C1Ptoqa-kJrCg@mail.gmail.com>
 <20110523090918.GA5474@elte.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 23 May 2011 09:01:44 -0700
Message-ID: <BANLkTim_pWfU0=ck8=F1kt_bwjtdGRDgdQ@mail.gmail.com>
Subject: Re: [bloat] Measuring header file bloat effects on kernel build
 performance: a more than 2x slowdown ...
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        David Miller <davem@davemloft.net>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 2:09 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> I've attached a totally hacky patch that removes all the big #include's from
> kernel/pid.c and includes all structure and API definitions explicitly.

Hmm.

A less hacky patch might be to split up "sched.h" into multiple
smaller things and at least get *part* of the way.

A lot of things want "struct task_struct" (and in some cases
thread_info, but that's already split).

Much fewer care about the signal stuff.

And many things probably don't even need the task_struct definition,
and might be perfectly happy with just function calls rather than
having intimate knowledge of the structure layout and an inline
function.

                       Linus
