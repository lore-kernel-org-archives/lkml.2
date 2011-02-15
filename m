Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085Ab1BOT2L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 14:28:11 -0500
Received: from www.tglx.de ([62.245.132.106]:33512 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755302Ab1BOT2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 14:28:10 -0500
Date: Tue, 15 Feb 2011 20:26:51 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrea Arcangeli <aarcange@redhat.com>
cc: Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Jan Beulich <JBeulich@novell.com>, Larry Woodman <lwoodman@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Hugh Dickins <hughd@google.com>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH] fix pgd_lock deadlock
In-Reply-To: <20110215190710.GL5935@random.random>
Message-ID: <alpine.LFD.2.00.1102152020590.26192@localhost6.localdomain6>
References: <4CB76E8B.2090309@goop.org> <4CC0AB73.8060609@goop.org> <20110203024838.GI5843@random.random> <4D4B1392.5090603@goop.org> <20110204012109.GP5843@random.random> <4D4C6F45.6010204@goop.org> <20110207232045.GJ3347@random.random>
 <20110215190710.GL5935@random.random>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Feb 2011, Andrea Arcangeli wrote:

> Hello,
> 
> Without this patch we can deadlock in the page_table_lock with NR_CPUS
> < 4 or THP on, with this patch we hopefully won't deadlock in the
> pgd_lock (if taken from irq). I can't see anything taking it from irq
> (maybe aio? to check I also tried the libaio testuite with no apparent
> VM_BUG_ON triggering), so unless somebody sees it, I think we should
> apply it. I've been running for a while with this patch applied
> without apparent problems. Other archs may follow suit if it's proven
> that there's nothing taking the pgd_lock from irq.
> 
> ===
> Subject: fix pgd_lock deadlock
> 
> From: Andrea Arcangeli <aarcange@redhat.com>
> 
> It's forbidden to take the page_table_lock with the irq disabled or if there's
> contention the IPIs (for tlb flushes) sent with the page_table_lock held will
> never run leading to a deadlock.

I really read this thing 5 times and still cannot make any sense of it.

You talk about page_table_lock and then fiddle with pgd_lock.

-ENOSENSE

	tglx

 
