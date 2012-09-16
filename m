Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542Ab2IPN1m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 09:27:42 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:17211 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751044Ab2IPN1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 09:27:40 -0400
X-Greylist: delayed 2828 seconds by postgrey-1.27 at vger.kernel.org; Sun, 16 Sep 2012 09:27:40 EDT
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19TdIav+q9INUXFZjDVmWIzQnAyEb1kCeg=
Date: Sun, 16 Sep 2012 08:40:15 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Ben Dooks <ben.dooks@codethink.co.uk>, Rob Landley <rob@landley.net>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 03/10] pinctrl: mvebu: kirkwood pinctrl driver
Message-ID: <20120916124015.GI5469@titan.lakedaemon.net>
References: <1344689809-6223-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1347550912-18021-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1347550912-18021-4-git-send-email-sebastian.hesselbarth@gmail.com>
 <20120916074652.GM28177@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120916074652.GM28177@lunn.ch>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 16, 2012 at 09:46:52AM +0200, Andrew Lunn wrote:
> > +++ b/Documentation/devicetree/bindings/pinctrl/marvell,kirkwood-pinctrl.txt
> > @@ -0,0 +1,279 @@
> > +* Marvell Kirkwood SoC pinctrl driver for mpp
> > +
> > +Please refer to marvell,mvebu-pinctrl.txt in this directory for common binding
> > +part and usage.
> > +
> > +Required properties:
> > +- compatible: "marvell,88f6180-pinctrl",
> > +              "marvell,88f6190-pinctrl", "marvell,88f6192-pinctrl",
> > +              "marvell,88f6281-pinctrl", "marvell,88f6282-pinctrl"
> > +
> > +This driver supports all kirkwood variants, i.e. 88f6180, 88f619x, and 88f628
> 
> Hi Sebastian 
> 
> The current MPP code determines for itself what chip it is running on.
> It can then check if a pin configuration is valid for the current
> run time environment.
> 
> Here you are suggesting we have to put into the DT what chip we expect
> to be on.
> 
> What is the advantage of this, over getting the information from the
> device itself?

The DT should describe the hardware as accurately as possible.  We can't
always assume Linux will be the only thing the DT is handed off to.

> If i wanted to mass convert all existing kirkwood DT boards over to
> use pinctrl, im stuck at the very first step. I've no idea what chip
> they use, it was not relevant before.

Let's try to do the DT correctly, and create a migration path for
kirkwood to work first, then migrate to using the DT fully.

thx,

Jason.
