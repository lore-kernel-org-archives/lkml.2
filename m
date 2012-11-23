Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161091Ab2KWJxN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 04:53:13 -0500
Received: from mail.skyhub.de ([78.46.96.112]:41129 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161071Ab2KWJxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 04:53:08 -0500
Date: Fri, 23 Nov 2012 10:53:02 +0100
From: Borislav Petkov <bp@alien8.de>
To: Mel Gorman <mgorman@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Alex Shi <lkml.alex@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/40] x86: mm: drop TLB flush from ptep_set_access_flags
Message-ID: <20121123095301.GB18765@x1.alien8.de>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Mel Gorman <mgorman@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Ingo Molnar <mingo@kernel.org>, Rik van Riel <riel@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Hugh Dickins <hughd@google.com>,
	Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
	Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
	Alex Shi <lkml.alex@gmail.com>,
	Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
	Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
References: <1353612353-1576-1-git-send-email-mgorman@suse.de>
 <1353612353-1576-3-git-send-email-mgorman@suse.de>
 <20121122205637.4e9112e2@pyramind.ukuu.org.uk>
 <20121123090909.GX8218@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121123090909.GX8218@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 23, 2012 at 09:09:09AM +0000, Mel Gorman wrote:
> You sortof can[1]. Borislav Petkov answered that they do
> https://lkml.org/lkml/2012/11/17/85 and quoted the manual at
> https://lkml.org/lkml/2012/10/29/414 saying that this should be ok.
> 
> [1] There is no delicate way of putting it. I've no idea what the
>     current status of current and former AMD kernel developers is.

All those based in Dresden don't work for AMD anymore.

But regardless, I've already confirmed with AMD design that this is
actually architectural and we're zapping the TLB entry on a #PF on all
relevant CPUs.

I'd still like to have some sort of an assertion there just in case but,
as Linus pointed out, that won't be easy. I'd guess it's up to you -mm
guys to think up something sick that works under CONFIG_DEBUG_VM :).

HTH.

-- 
Regards/Gruss,
Boris.
