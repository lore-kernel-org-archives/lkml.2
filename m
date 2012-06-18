Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514Ab2FRH7A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 03:59:00 -0400
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:35067 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750748Ab2FRH66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 03:58:58 -0400
Date: Mon, 18 Jun 2012 13:28:38 +0530
From: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Subject: Re: Fwd: [PATCH 1/3] i2c: Add Device Tree support to the Nomadik
 I2C driver
Message-ID: <20120618075834.GA14293@bnru02>
References: <4FD8BAD2.50703@linaro.org>
 <CACRpkdZFi34nChnMEo6yik67zk9owZLk-6zcdP7mmOXyLz8uqQ@mail.gmail.com>
 <4FDAFA17.6050502@linaro.org>
 <CAE2-_9rRYxjU9QQgtBv9ReMY5x+oRiJG1cDQahYHanjDrwVUYA@mail.gmail.com>
 <20120615115042.GA27480@bnru02>
 <4FDB2E57.4030904@linaro.org>
 <20120615130544.GA28537@bnru02>
 <4FDB3642.5030804@linaro.org>
 <CACRpkdZ7ESKhokk8Z+6sC9Kq+jPztFNwzger0Db7nCD1fPnG1A@mail.gmail.com>
 <4FDED62D.6030008@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4FDED62D.6030008@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 09:18:05 +0200, Lee Jones wrote:
> On 17/06/12 18:43, Linus Walleij wrote:
> > Gah, what a thread...
> >
> > On Fri, Jun 15, 2012 at 3:18 PM, Lee Jones<lee.jones@linaro.org>  wrote:
> >> On 15/06/12 14:05, Srinidhi Kasagar wrote:
> >>> On Fri, Jun 15, 2012 at 14:45:11 +0200, Lee Jones wrote:
> >>>> On 15/06/12 12:50, Srinidhi Kasagar wrote:
> >
> >>>>>> +static struct nmk_i2c_controller u8500_i2c = {
> >>>>>> +       /*
> >>>>>> +        * Slave data setup time; 250ns, 100ns, and 10ns, which
> >>>>>> +        * is 14, 6 and 2 respectively for a 48Mhz i2c clock.
> >>>>>> +        */
> >>>>>> +       .slsu           = 0xe,
> >>>>>> +       .tft            = 1,      /* Tx FIFO threshold */
> >>>>>> +       .rft            = 8,      /* Rx FIFO threshold */
> >>>>>> +       .clk_freq       = 100000, /* std. mode operation */
> >>>>>> +       .timeout        = 200,    /* Slave response timeout(ms) */
> >>>>>> +       .sm             = I2C_FREQ_MODE_FAST,
> >>>>>
> >>>>> How is this possible? you are setting clk_freq as 100kb/s and mode
> >>>>> as fast mode which is supposed to be 400kb/s.
> >>>>
> >>>> That's not how I read it:
> >>>
> >>> But it is not readable. It confuses people.
> >>
> >> I understood it. :)
> >>
> >> If you think it's unclear speak to the author, Linus. He's CC'ed.
> >
> > Author of what? The i2c driver was written by Srinidhi. (The
> > MODULE_AUTHOR() clause should be a good hint...)
> 
> Actually, we appear to have our wires crossed. You wrote the board data 
> stuff below, which changes the mode from STANDARD to FAST, no doubt 
> using Srinidhi's struct explanation comments found in 
> arch/arm/plat-nomadik/include/plat/i2c.h.
> 
>  > I'll cook a separate patch for this or something.
> 
> Cool, thanks Linus.
> 
> But you're correct in what you say Linus. Srinidhi, the comments which 
> are you say are confusing are the bits you are the author of: 
> e208c447bd728920e4f3d438a706344ea31249b9?

yes, it is of course evident that it's my commit from git.
I think you are not catching my point. What I mean is:
fast mode devices are downward compatible and can communicate
with the devices with standard only mode. Those comments in that
enum says exactly that (with "up to" keyword). However the code
which configures the bus in fast mode and restrict the frequency
to operate in 100 kb/s without any reason, and this creates
confusion..

Perhaps, I think we need to remove one of these
parameters as configurable options and derive out the
frequency based on the mode of operation..

/srinidhi
