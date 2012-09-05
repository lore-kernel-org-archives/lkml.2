Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759149Ab2IESU3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 14:20:29 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:22701 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083Ab2IESU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 14:20:27 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX182Vyb/8Gwnjb6nPytt6lqu
Date: Wed, 5 Sep 2012 11:20:24 -0700
From: Tony Lindgren <tony@atomide.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 0/2] pinctrl: pinctrl-single: new type:
 pinctrl-single,bits
Message-ID: <20120905182023.GG1303@atomide.com>
References: <1346835718-21325-1-git-send-email-peter.ujfalusi@ti.com>
 <CACRpkda9_qK9jrJSAYo5NDiadrX2-J5mgMapY6pp__XzanUhZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkda9_qK9jrJSAYo5NDiadrX2-J5mgMapY6pp__XzanUhZA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Walleij <linus.walleij@linaro.org> [120905 05:11]:
> On Wed, Sep 5, 2012 at 11:01 AM, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
> 
> > When configuring pinmux with pinctrl-single there could be a case when one
> > register is used to configure mux for more than one pin.
> > In this case the use of pinctrl-single,pins is a bit problematic since we can
> > only update the whole register (restricted by the mask).
> > In such a situations the pinctrl-single,bits could provide a safe way to handle
> > the mux.
> >
> > pinctrl-single,bits takes three parameters: <reg offset, value, sub-mask>
> > The sub mask is used to mask part of the register to make sure we do not change
> > bits outside of the scope of this pin.
> >
> > The first patch in this series is to fix the previous pinctrl-since,pins
> > implementation because it was not using the mask on the value which could result
> > changed bits outside of the mask.
> 
> This looks sane to me, but I'd like Tony to ACK before I apply it.

Cool, this should allow handling cases where some pinctrl devices can have
extra aux registers for signal strength etc for some of the pins.

Will take a look.

Tony
