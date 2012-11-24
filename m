Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751632Ab2KXPAS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 10:00:18 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:22590 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751448Ab2KXPAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 10:00:16 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX187NYUmxPh0GtkBbwJzIEgMC/XYuu7GNbc=
Date: Sat, 24 Nov 2012 10:00:04 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Axel Lin <axel.lin@ingics.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/4] ARM: Dove: Convert to DT GPIO and pinctrl
Message-ID: <20121124150004.GQ15800@titan.lakedaemon.net>
References: <1353317996-20841-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1353317996-20841-4-git-send-email-sebastian.hesselbarth@gmail.com>
 <20121124023942.GO15800@titan.lakedaemon.net>
 <20121124080240.3f600e89@skate>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121124080240.3f600e89@skate>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 24, 2012 at 08:02:40AM +0100, Thomas Petazzoni wrote:
> Dear Jason Cooper,
> 
> On Fri, 23 Nov 2012 21:39:42 -0500, Jason Cooper wrote:
> > > +		pinctrl: pinctrl@d0200 {
> > > +			compatible = "marvell,dove-pinctrl";
> > > +			reg = <0xd0200 0x10>;
> > > +			clocks = <&gate_clk 22>;
> > 
> > The above line broke the dtbs build target for dove_defconfig.  I have
> > removed it.  Please let me know if that is not the correct answer.  This
> > was the only occurence of 'clk' in arch/arm/boot/dts/dove* .
> 
> Are you sure you merged
> 
>  [PATCH 7/8] ARM: dove: switch to DT clock providers ?
> 
> This one clearly adds gate_clk in dove.dtsi. This patch was part of the
> pull request:
> 
> Subject: [GIT PULL v3] core, cpu and gated clocks for mvebu
> Date: Tue, 20 Nov 2012 15:31:08 +0100

Yes, so that's what I thought happened.  This would have made orion/dt
depend upon mvebu/everything.  It already had two other dependencies.
Not ideal.

The good thing is, the build is not broken.  Once v3.8-rc1 drops with
all of our stuff merged, I'll post a fixup patch adding this back in.

thx,

Jason.
