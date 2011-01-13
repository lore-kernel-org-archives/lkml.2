Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340Ab1AMRdx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 12:33:53 -0500
Received: from www.tglx.de ([62.245.132.106]:58645 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757284Ab1AMRdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 12:33:51 -0500
Date: Thu, 13 Jan 2011 18:33:41 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sven Neumann <s.neumann@raumfeld.com>
cc: Daniel Mack <daniel@caiaq.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: resume regression in 2.6.37
In-Reply-To: <1294938961.10740.24.camel@sven>
Message-ID: <alpine.LFD.2.00.1101131827080.2678@localhost6.localdomain6>
References: <1294933492.2535.23.camel@sven> <alpine.LFD.2.00.1101131720350.2678@localhost6.localdomain6> <1294938961.10740.24.camel@sven>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Jan 2011, Sven Neumann wrote:
> On Thu, 2011-01-13 at 17:28 +0100, Thomas Gleixner wrote:
> > On Thu, 13 Jan 2011, Sven Neumann wrote:
> > > Any idea on how to proceed from here? I don't think I can just revert
> > > this commit and expect things to work, right?
> > 
> > Well, I somehow doubt, that this is the real culprit. The patch does
> > not change anything of the set_wake() functionality. It's a functional
> > equivivalent wrapper, nothing else.
> > 
> > Can you revert it on top of 2.6.37 and verify that it helps ?
> 
> I've done that now and while it doesn't solve the problem completely, I
> can definitely say that reverting the change does make a difference. 

Hmm. I have to admit that this confuses the hell out of me.

> Without the revert there is absolutely no sign of resume. With the
> change reverted I can see that the PXA powers up again, there's an LED
> showing that the USB controller has power again. Unfortunately there's
> seems to be another problem and the resume doesn't complete. I've tried
> to get console output by using no_console_suspend, but there's just
> gibberish on the console after resume :(
> 
> Any idea on how to proceed from here? I could perhaps ask our hardware
> engineer to try find out where exactly we are stuck in the resume. But
> I'd like to avoid that if possible.

Can you stick a printk into the set_wake() function of that irq chip
and print the irq and on arguments and the return value . Run that
with both stock 2.6.37 and the patch reverted.

Thanks,

	tglx


