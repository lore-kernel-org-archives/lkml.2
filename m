Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061Ab1DUMDh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 08:03:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47255 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751867Ab1DUMDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 08:03:36 -0400
Date: Thu, 21 Apr 2011 13:03:28 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Haojian Zhuang <hzhuang1@marvell.com>
Cc: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "haojian.zhuang@gmail.com" <haojian.zhuang@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>
Subject: Re: [PATCH 13/14] regulator: max8925: fix not add device if
 missing init data
Message-ID: <20110421120327.GD11788@opensource.wolfsonmicro.com>
References: <1303135451-26362-14-git-send-email-haojian.zhuang@marvell.com>
 <1303300539-2941-1-git-send-email-haojian.zhuang@marvell.com>
 <20110421104204.GB11788@opensource.wolfsonmicro.com>
 <25B60CDC2F704E4E9D88FFD52780CB4C05CF0EF027@SC-VEXCH1.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25B60CDC2F704E4E9D88FFD52780CB4C05CF0EF027@SC-VEXCH1.marvell.com>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 04:13:28AM -0700, Haojian Zhuang wrote:

> >> +static struct regulator_init_data
> >regulator_pdata[ARRAY_SIZE(regulator_devs)];

> >That looks really suspicious, what happens if there's two of these
> >devices in the system?

> It's impossible to use two PMIC in one system. At least, I didn't hear.

I don't believe that.  It's not going to be a common case but it will be
possible.

> >It's really unclear why the array is needed at all if you're registering
> >the devices one at a time.

> Although there're a lot of regulators, maybe only parts of them are used.
> So only add the necessary one. Others will be passed. The number is got
> from platform data.

You're missing the point here.  You're registering a device at a time
but for some reason the platform data is being stored in an array in
order to pass it in, even though only a single element in the array is
in use.

> >> -	if (pdata && pdata->regulator[0]) {
> >> -		ret = mfd_add_devices(chip->dev, 0, &regulator_devs[0],
> >> -				      ARRAY_SIZE(regulator_devs),
> >> -				      &regulator_resources[0], 0);
> >> -		if (ret < 0) {
> >> -			dev_err(chip->dev, "Failed to add regulator subdev\n");
> >> -			goto out_dev;
> >> -		}

> >Surely the only change that's needed here is to remove the check to see
> >if pdata->regulator[0] is non-null?

> All above changes are necessary to me.

What makes you say this?  If you remove the check for the first entry
being null then the driver will go and register all the regulators which
seems fine.  That seems like it fixes the problem with skipping all the
regulators if the first one has no platform data.

You're really not explaining the changes you're trying to make here
terribly well, the changes you're making seem very substantial relative
to what you say you're trying to do.
