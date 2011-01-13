Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271Ab1AMRQE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 12:16:04 -0500
Received: from vwp2514.webpack.hosteurope.de ([87.230.42.24]:57340 "EHLO
	vwp2514.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756855Ab1AMRQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 12:16:02 -0500
Subject: Re: resume regression in 2.6.37
From: Sven Neumann <s.neumann@raumfeld.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Daniel Mack <daniel@caiaq.de>
In-Reply-To: <alpine.LFD.2.00.1101131720350.2678@localhost6.localdomain6>
References: <1294933492.2535.23.camel@sven>
	 <alpine.LFD.2.00.1101131720350.2678@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Organization: RAUMFELD GmbH
Date: Thu, 13 Jan 2011 18:16:01 +0100
Message-ID: <1294938961.10740.24.camel@sven>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;s.neumann@raumfeld.com;1294938962;f732c47c;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-13 at 17:28 +0100, Thomas Gleixner wrote:
> On Thu, 13 Jan 2011, Sven Neumann wrote:
> > Now I've tried to update the kernel to 2.6.37. After fixing the already
> > reported NULL pointer dereference on bootup in pxa3xx_nand_probe(), the
> > device seems to work fine until I suspend it and then try to wake it up
> > from suspend. Suspend seems to work fine, no warnings whatsoever.
> > However there is absolutely no sign of resume.
> > 
> > I've used git bisect to track this down to the following commit:
> > 
> > 
> > commit 2f7e99bb9be6a2d8d7b808dc86037710cc8b7bf1
> > Author: Thomas Gleixner <tglx@linutronix.de>
> > Date:   Mon Sep 27 12:45:50 2010 +0000
> > 
> >     genirq: Provide compat handling for chip->set_wake()
> >     
> >     Wrap the old chip function set_wake() until the migration is
> >     complete and the old chip functions are removed.
> >     
> >     Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> >     Cc: Peter Zijlstra <peterz@infradead.org>
> >     LKML-Reference: <20100927121842.927527393@linutronix.de>
> >     Reviewed-by: H. Peter Anvin <hpa@zytor.com>
> >     Reviewed-by: Ingo Molnar <mingo@elte.hu>
> > 
> > 
> > Any idea on how to proceed from here? I don't think I can just revert
> > this commit and expect things to work, right?
> 
> Well, I somehow doubt, that this is the real culprit. The patch does
> not change anything of the set_wake() functionality. It's a functional
> equivivalent wrapper, nothing else.
> 
> Can you revert it on top of 2.6.37 and verify that it helps ?

I've done that now and while it doesn't solve the problem completely, I
can definitely say that reverting the change does make a difference. 

Without the revert there is absolutely no sign of resume. With the
change reverted I can see that the PXA powers up again, there's an LED
showing that the USB controller has power again. Unfortunately there's
seems to be another problem and the resume doesn't complete. I've tried
to get console output by using no_console_suspend, but there's just
gibberish on the console after resume :(

Any idea on how to proceed from here? I could perhaps ask our hardware
engineer to try find out where exactly we are stuck in the resume. But
I'd like to avoid that if possible.


Thanks,
Sven


