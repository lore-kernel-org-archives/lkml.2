Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105Ab2I1Pv2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 11:51:28 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58674 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756195Ab2I1Pv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 11:51:27 -0400
Date: Fri, 28 Sep 2012 16:51:22 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: Fabio Estevam <fabio.estevam@freescale.com>, sameo@linux.intel.com,
        Marek Vasut <marex@denx.de>, ashish.jangam@kpitcummins.com,
        dchen@diasemi.com, arnd@arndb.de, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mfd: da9052-core: Use regmap_irq_get_virq() and fix
 the probe
Message-ID: <20120928155121.GA22510@opensource.wolfsonmicro.com>
References: <1348797458-2562-1-git-send-email-festevam@gmail.com>
 <20120928104944.GB30869@opensource.wolfsonmicro.com>
 <5065B534.7040602@freescale.com>
 <20120928142924.GA22101@opensource.wolfsonmicro.com>
 <CAOMZO5DgOjs06BJZWsEay-jP5pjzMNTZTZnvAvzAd-JD9kqs1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMZO5DgOjs06BJZWsEay-jP5pjzMNTZTZnvAvzAd-JD9kqs1g@mail.gmail.com>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 12:37:35PM -0300, Fabio Estevam wrote:
> On Fri, Sep 28, 2012 at 11:29 AM, Mark Brown

> > No, this doesn't support linear domains, if you're going to do this it'd
> > be better to just leave it as irq_base though as discussed that's not
> > ideal.  When I've done these conversions I've just done the virq
> > conversion at every use.

> Ok, so if I understand you correctly you suggest that Samuel applies
> the v1 of the patch:
> https://lkml.org/lkml/2012/9/26/551

> Please confirm.

Well, I'd really rather fix it to work with linear domains while we're
at it.  Right now it's mostly working by accident rather than design
(and even for legacy domains it's doing the wrong thing since it doesn't
pass the irq_base into mfd_add_devices).  This is especially true if
we're looking at making the device DT only in which case there's really
no reason to use anything other than a linear domain.

But yes, of the changes posted thus far this is the best one.
