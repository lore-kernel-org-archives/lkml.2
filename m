Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491Ab0JYApx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 20:45:53 -0400
Received: from trinity.fluff.org ([89.16.178.74]:43972 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265Ab0JYApv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 20:45:51 -0400
Date: Mon, 25 Oct 2010 01:45:41 +0100
From: Ben Dooks <ben-i2c@fluff.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Jean Delvare <khali@linux-fr.org>,
        "Hennerich, Michael" <Michael.Hennerich@analog.com>,
        David Brownell <david-b@pacbell.net>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Device-drivers-devel] [PATCH] i2c: add irq_flags to board info
Message-ID: <20101025004541.GD21564@trinity.fluff.org>
References: <1287359019-1476-1-git-send-email-vapier@gentoo.org> <20101018103610.77b7e605@endymion.delvare> <544AC56F16B56944AEC3BD4E3D5917713094520EDB@LIMKCMBX1.ad.analog.com> <20101018140136.2b44d29e@endymion.delvare> <544AC56F16B56944AEC3BD4E3D5917713094520FA6@LIMKCMBX1.ad.analog.com> <20101018163357.659efe25@endymion.delvare> <AANLkTi=fAYqxsGre9kOt9Z8nDXZ9JFjZtKUiMrE3Qn9b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=fAYqxsGre9kOt9Z8nDXZ9JFjZtKUiMrE3Qn9b@mail.gmail.com>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 03:51:49PM -0400, Mike Frysinger wrote:
> On Mon, Oct 18, 2010 at 10:33, Jean Delvare wrote:
> > Why do we have set_irq_type() if we're not supposed to call it? I am
> > not claiming to be an expert in the area, but it seems totally
> > reasonable to me that the same piece of code instantiating an I2C
> > device is also responsible for setting its IRQ type.
> 
> but we're back to the same issue mentioned earlier -- you cant have a
> single kernel build with modules supporting multiple drivers
> simultaneously.  we like to ship development boards with a single
> kernel build on it with many modules.  then people can pick the addon
> boards they wish to prototype with at runtime by plugging in the card
> and loading the module.

I also dislike set_irq_type() as it doesn't check whether there is anyone
registered with the interrupt, which means that you could set the irq
type of someone else's irq.

I wonder if we should pass a struct resource instead, in case there
are multiple interrupt sources, as well as having it registered with
the right resource systems.

-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

