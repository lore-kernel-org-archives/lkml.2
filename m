Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932596Ab0CaXCv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 19:02:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54712 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932330Ab0CaXCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 19:02:47 -0400
Date: Thu, 1 Apr 2010 01:02:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: James Morris <jmorris@namei.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
       linux-kernel@vger.kernel.org, airlied@linux.ie,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: Config NO_BOOTMEM breaks my amd64 box
Message-ID: <20100331230237.GA31279@elte.hu>
References: <alpine.LRH.2.00.1003311539490.23281@tundra.namei.org>
 <4BB2EB1B.8090303@zytor.com>
 <alpine.LRH.2.00.1003311747040.23859@tundra.namei.org>
 <20100331185916.GA12306@elte.hu>
 <alpine.LRH.2.00.1004010952080.31957@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1004010952080.31957@tundra.namei.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* James Morris <jmorris@namei.org> wrote:

> On Wed, 31 Mar 2010, Ingo Molnar wrote:
> 
> > > 
> > > Yes, it was happening with -rc3.
> > 
> > Could you please send the bootlog that Yinghai asked for, plus also one that 
> > you get with NO_BOOTMEM turned off (for comparison)?
> 
> I don't have the old boot logs, and have since upgraded the system 
> further.  

Please, could you send any bootlog then that we could work from? That way we 
could check the memory layout and guess the rough shape of the early 
allocations, etc.

> IIRC, the boot was failing after not being able to find the root fs 
> (ext3/lvm/raid0).  I thought it was a dracut issue, but it seemed to be 
> fixed by enabling bootmem.

Ok - initrd unpack failing or initial mount failing is consistent with the 
initrd getting corrupted by overlapping early reservations due to allocator 
bug.

> > Also, when did you first hit this bug? This code has been upstream for 
> > almost a month, and it was in linux-next before that - so you should have 
> > hit this much sooner. A rough timeframe would suffice. I suppose you were 
> > booting upstream kernels during the merge window as well?
> 
> In this case, in the last few days (also when I first saw or noticed the 
> bootmem option).  I was booting relatively recent linus kernels during the 
> merge window, although my main work was being done on an older upstream 
> kernel.

Ok, so it's not an old regression but possibly a bug in one of the fixes. Not 
good.

	Ingo
