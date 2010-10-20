Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab0JTRzW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 13:55:22 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1406 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863Ab0JTRzV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 13:55:21 -0400
X-PGP-Universal: processed;
	by hqnvupgp03.nvidia.com on Wed, 20 Oct 2010 10:55:14 -0700
From: Rhyland Klein <rklein@nvidia.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "cboutatmailru@gmail.com" <cboutatmailru@gmail.com>,
        Andrew Chew <AChew@nvidia.com>, "olof@lixom.net" <olof@lixom.net>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 20 Oct 2010 10:52:08 -0700
Subject: RE: [PATCH 1/1] power: bq24617: Adding initial charger support
Thread-Topic: [PATCH 1/1] power: bq24617: Adding initial charger support
Thread-Index: ActwA0M/yhGpE0igR4ybrf6+x/IxCQAewgKQ
Message-ID: <E88A1D35AF5437468E5B14C7C4BA61C702D37CA98C@HQMAIL01.nvidia.com>
References: <1287541031-17409-1-git-send-email-rklein@nvidia.com>
 <20101020030235.GA25392@sirena.org.uk>
In-Reply-To: <20101020030235.GA25392@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
> Sent: Tuesday, October 19, 2010 8:03 PM
> To: Rhyland Klein
> Cc: cboutatmailru@gmail.com; Andrew Chew; olof@lixom.net; linux-
> tegra@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 1/1] power: bq24617: Adding initial charger support
> 
> On Tue, Oct 19, 2010 at 07:17:11PM -0700, rklein@nvidia.com wrote:
> > From: Rhyland Klein <rklein@nvidia.com>
> >
> > Initial checkin adding basic support for the TI BQ24617 battery charger
> on the
> > Nvidia Tegra architecture.
> 
> Why is this driver dependant on the CPU?  I can't see anything in the
> code that makes it so.

In hindsight this isn't the most accurate statement. The driver itself is not dependent on the CPU, it is dependent on the platform design, and in particular requires the PG line to be piped in through a GPIO. Would it make more sense to make the driver dependent on GPIO instead?

> 
> > +	if (old_status != -1 &&
> > +		old_status != new_status) {
> > +		dev_dbg(&chip->pdev->dev,
> > +			"%s: %i -> %i\n", __func__, old_status,
> > +			new_status);
> > +		kobject_uevent(&chip->power_supply.dev->kobj, KOBJ_CHANGE);
> 
> power_supply_changed().

Alright.

> 
> > +static irqreturn_t bq24617_irq_switch(int irq, void *devid)
> > +{
> > +	struct bq24617_info *chip = devid;
> > +
> > +	schedule_work(&chip->ac_work);
> > +
> > +	return IRQ_HANDLED;
> > +}
> 
> You're looking for a threaded IRQ handler here - use
> request_threaded_irq() with no primary handler.

Alright I will look into this.
