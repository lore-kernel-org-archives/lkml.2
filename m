Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565Ab1EPOPw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 10:15:52 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:40756 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755358Ab1EPOPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 10:15:50 -0400
Date: Mon, 16 May 2011 19:45:34 +0530
From: Shreshtha Kumar SAHU <shreshthakumar.sahu@stericsson.com>
To: Russell King <rmk@arm.linux.org.uk>
Cc: "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>
Subject: Re: [PATCH 2/2] amba pl011: platform data for reg lockup and glitch
Message-ID: <20110516141532.GA22311@bnru02.bnr.st.com>
References: <1305550879-28945-1-git-send-email-shreshthakumar.sahu@stericsson.com>
 <1305550879-28945-2-git-send-email-shreshthakumar.sahu@stericsson.com>
 <20110516130905.GA12192@flint.arm.linux.org.uk>
 <20110516140045.GA9387@bnru02.bnr.st.com>
 <20110516140541.GA22445@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110516140541.GA22445@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 16:05:41 +0200, Russell King wrote:
> On Mon, May 16, 2011 at 07:30:46PM +0530, Shreshtha Kumar SAHU wrote:
> > On Mon, May 16, 2011 at 15:09:05 +0200, Russell King wrote:
> > > On Mon, May 16, 2011 at 06:31:19PM +0530, Shreshtha Kumar SAHU wrote:
> > > > From: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
> > > >
> > > > This patch provides platform data for following
> > > >  - uart reset function to assist uart register lockup workaround
> > > >
> > > >  - init/exit function to fix glitch in the tx pin in tty_open
> > > >       when tty port0 is opened a glitch is seen in the tx line
> > > >       of uart0. This happens in __pl011_startup() when tx fifo
> > > >       interrupt is provoked into asserting.
> > > 
> > > I was trying to work out where that is, but i can't find this function.
> > > Is your patch against a different version of the driver?
> > sorry, the function names in commit message is wrong by mistake.
> > It should be - "This happens in pl011_startup() when tx 
> > fifo interrupt is provoked into asserting."
> > I will send out a new patch with corrected commit mesaage.
> 
> Have you tracked down why this happens?
> 
> Is it the switching into and out of loopback mode, or does loopback mode
> not prevent the transmit pin toggling?
As I tried to get the cause for it, I found it is not due to switching in
and out of loopback mode. It was found to be default behaviour of the hardware.
Even in loopback mode data is transmitted out to pins.
> 
> -- 
> Russell King
>  Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
>  maintainer of:
