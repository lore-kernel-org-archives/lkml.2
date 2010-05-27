Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933130Ab0E0WIk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 18:08:40 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:45385 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843Ab0E0WIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 18:08:39 -0400
Date: Thu, 27 May 2010 23:08:19 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Paul@smtp1.linux-foundation.org, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100527220819.GA10602@srcf.ucam.org>
References: <20100527161943.GA32764@srcf.ucam.org> <alpine.LFD.2.00.1005271901020.3032@localhost.localdomain> <20100527170740.GA1980@srcf.ucam.org> <1274980391.27810.5552.camel@twins> <20100527171644.GA2468@srcf.ucam.org> <1274980856.27810.5582.camel@twins> <20100527172510.GC2468@srcf.ucam.org> <20100527223751.7af3b5ee@lxorguk.ukuu.org.uk> <20100527213635.GA9916@srcf.ucam.org> <20100527225637.57a336ad@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100527225637.57a336ad@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 10:56:37PM +0100, Alan Cox wrote:
> On Thu, 27 May 2010 22:36:35 +0100
> Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > No it doesn't. The kernel continues executing anything that was on the 
> 
> Would you like to come and watch my laptop resume ? With printk's if you
> want. You appear at this point to be arguing that bumble bees can't
> fly, while watching one.

The kernel performs no explicit notification to userspace. With legacy 
graphics setups you'll get a VT switch, but X is entirely unaware that 
that's due to suspend and that's going away in any case. On a typical 
setup it's not even the kernel that does the VT switch to and from X - 
that's handled by a script that happens to be on the runqueue. So yeah, 
things kind of work as you suggest right now - but only by accident, not 
design. What you're describing requires a new interface to inform 
interested bits of userspace whenever you transition from your deep idle 
state into a less deep one.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
