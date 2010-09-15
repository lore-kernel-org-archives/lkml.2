Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab0IOOnJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 10:43:09 -0400
Received: from www.tglx.de ([62.245.132.106]:51300 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754154Ab0IOOnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 10:43:08 -0400
Date: Wed, 15 Sep 2010 16:42:38 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Borislav Petkov <borislav.petkov@amd.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Nix <nix@esperi.org.uk>,
        Artur Skawina <art.08.09@gmail.com>,
        Damien Wyart <damien.wyart@free.fr>,
        John Drescher <drescherjm@gmail.com>,
        Venkatesh Pallipadi <venki@google.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH RFC] x86: hpet: Avoid the readback penalty
In-Reply-To: <20100915144034.GC968@aftab>
Message-ID: <alpine.LFD.2.00.1009151640160.2416@localhost6.localdomain6>
References: <tip-54ff7e595d763d894104d421b103a89f7becf47c@git.kernel.org> <alpine.LFD.2.00.1009151500060.2416@localhost6.localdomain6> <20100915144034.GC968@aftab>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Sep 2010, Borislav Petkov wrote:

> From: Thomas Gleixner <tglx@linutronix.de>
> Date: Wed, Sep 15, 2010 at 09:11:57AM -0400
> 
> > On Tue, 14 Sep 2010, tip-bot for Thomas Gleixner wrote:
> > > x86: hpet: Work around hardware stupidity
> > 
> > After my brain recovered from yesterdays exposure with the x86 timer
> > horror, I came up with a different solution for this problem, which
> > avoids the readback of the compare register completely. It works
> > nicely on my affected ATI system, but needs some exposure to the other
> > machines.
> 
> Will run in on a couple of SBx00 machines I got here.
> 
> ...
> 
> > If cmp is less than 8 HPET clock cycles, then we decide that the event
> > has happened already and return -ETIME. That covers the above #1 and
> > #2 problems which would cause a wait for HPET wraparound (~306
> > seconds).
> 
> Make sense. I guess you're choosing a value of 8 just to be on the safe
> side wrt to HPET clock cycles it takes to write the cmp register?

Yes, I do _NOT_ trust those hardware dudes at all. A factor 4 seems to
be an appropriate choice:)

Thanks,

	tglx
