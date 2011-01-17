Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107Ab1AQOEs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 09:04:48 -0500
Received: from vwp2514.webpack.hosteurope.de ([87.230.42.24]:36660 "EHLO
	vwp2514.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751210Ab1AQOEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 09:04:47 -0500
Subject: Re: resume regression in 2.6.37
From: Sven Neumann <s.neumann@raumfeld.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Daniel Mack <daniel@caiaq.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <alpine.LFD.2.00.1101171142380.2678@localhost6.localdomain6>
References: <1294933492.2535.23.camel@sven>
	 <alpine.LFD.2.00.1101131720350.2678@localhost6.localdomain6>
	 <1294938961.10740.24.camel@sven>
	 <alpine.LFD.2.00.1101131827080.2678@localhost6.localdomain6>
	 <1295260580.2060.29.camel@sven>
	 <alpine.LFD.2.00.1101171142380.2678@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Organization: RAUMFELD GmbH
Date: Mon, 17 Jan 2011 15:04:43 +0100
Message-ID: <1295273083.2060.34.camel@sven>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;s.neumann@raumfeld.com;1295273087;46c1e9a9;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-17 at 13:40 +0100, Thomas Gleixner wrote:
> On Mon, 17 Jan 2011, Sven Neumann wrote:
> 
> > On Thu, 2011-01-13 at 18:33 +0100, Thomas Gleixner wrote:
> > 
> > > > Without the revert there is absolutely no sign of resume. With the
> > > > change reverted I can see that the PXA powers up again, there's an LED
> > > > showing that the USB controller has power again. Unfortunately there's
> > > > seems to be another problem and the resume doesn't complete. I've tried
> > > > to get console output by using no_console_suspend, but there's just
> > > > gibberish on the console after resume :(
> > > > 
> > > > Any idea on how to proceed from here? I could perhaps ask our hardware
> > > > engineer to try find out where exactly we are stuck in the resume. But
> > > > I'd like to avoid that if possible.
> > > 
> > > Can you stick a printk into the set_wake() function of that irq chip
> > > and print the irq and on arguments and the return value . Run that
> > > with both stock 2.6.37 and the patch reverted.
> > 
> > pxa3xx_set_wake(31, 1) returns 0
> > 
> > Same result with stock 2.6.37 and the patch reverted. Except that
> > without the patch reverted, the device doesn't power up again.
> 
> Ok, can we agree that the patch has no functional impact on the
> set_wake function? And I don't see a reason why reverting that patch
> results in a working resume. That does not make sense at all. Which
> compiler version are you using ?

I agree that this is all very weird and as far as I understand the patch
it should have no functional impact. Unfortunately reverting the patch
does not result in a working resume, but at least it makes a difference
and at the moment it's the only trace I have.

My cross-compile tool-chain uses GCC 4.3.5.


Sven


