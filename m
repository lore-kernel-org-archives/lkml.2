Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab0HSNGg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 09:06:36 -0400
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:40278 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752860Ab0HSNGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 09:06:35 -0400
Date: Thu, 19 Aug 2010 18:36:05 +0530
From: Rabin Vincent <rabin.vincent@stericsson.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [RFC] gpio/stmpe: add bitmask to block requests to unavailable
 GPIOs
Message-ID: <20100819130605.GA25901@bnru01.bnr.st.com>
References: <1281971684-16505-1-git-send-email-w.sang@pengutronix.de>
 <20100818100950.GA19706@bnru01.bnr.st.com>
 <20100818103137.GB3528@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100818103137.GB3528@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 18, 2010 at 12:31:37 +0200, Wolfram Sang wrote:
> On Wed, Aug 18, 2010 at 03:39:50PM +0530, Rabin VINCENT wrote:
> > On Mon, Aug 16, 2010 at 17:14:44 +0200, Wolfram Sang wrote:
> > > GPIOs on these controller are multi-functional. If you decided to use
> > > some of them e.g. as input channels for the ADC, you surely don't want
> > > those pins to be reassigned as simple GPIOs (which may be triggered even
> > > from userspace via 'export'). Same for the touchscreen controller pins.
> > > Since knowledge about the hardware is needed to decide which GPIOs to
> > > reserve, let this bitmask be inside platform_data and provide some
> > > defines to assist potential users.
> > 
> > Could this be done without the platform data, say something like the
> > below?  (Though this does assume that nobody tries to request GPIOs
> > before the STMPE subdrivers reserve their pins.)
> > 
> 
> While I'd also like to skip the additional platform_data entry, your
> last comment is in deed a drawback.

Yes, especially if the subdrivers are dynamically loaded.  Your patch is
fine with me: 

Acked-by: Rabin Vincent <rabin.vincent@stericsson.com>

The only minor comment is that the STMPE_GPIO_NOREQ_811_TOUCH name could
perhaps be clearer.  STMPE811_GPIO_NOREQ_TOUCHSCREEN, maybe?

Rabin
