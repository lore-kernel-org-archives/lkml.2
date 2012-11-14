Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932735Ab2KNIgb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 03:36:31 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:36575 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578Ab2KNIga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 03:36:30 -0500
MIME-Version: 1.0
In-Reply-To: <20121114072855.GF7407@opensource.wolfsonmicro.com>
References: <25B60CDC2F704E4E9D88FFD52780CB4C060FBEA29A@SC-VEXCH1.marvell.com>
	<CADz5_gLC=z_VYrNq8q3dU7L6im7shSz-Sn6Tzym2mRZONwpgUg@mail.gmail.com>
	<20121114072855.GF7407@opensource.wolfsonmicro.com>
Date: Wed, 14 Nov 2012 16:36:28 +0800
Message-ID: <CADz5_gLb5ZRHLZHw1sDDWzu4QgOR7JXnaRMEXxETNzVsu1Wq1A@mail.gmail.com>
Subject: Re: FW: [PATCH v2] mmc: sdhci: apply voltage range check only for
 non-fixed regulators
From: Kevin Liu <keyuan.liu@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: m.szyprowski@samsung.com, Chris Ball <cjb@laptop.org>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, lrg@ti.com,
        Philip Rakity <prakity@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/14 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Wed, Nov 14, 2012 at 03:11:37PM +0800, Kevin Liu wrote:
>
>> -             ret = regulator_set_voltage(host->vqmmc, 3300000, 3300000);
>> +             ret = regulator_set_voltage(host->vqmmc, 2700000, 3600000);
>
> Should this be regulator_set_voltage_tol()?  Otherwise it'd be good to
> explain where the numbers come from.
In SD physical layer spec 3.01 chapter 6.6.1, the threshold level for
voltage range is defined as below:
Vdd(min) = 2.7V while Vdd(max) = 3.6V.
The card should work within the voltage range.

If you are afraid the voltage value is too aggressive, maybe we can
use regulator_set_voltage_tol() to set a smaller range.
But which range should be reasonable?

>> +             ret = regulator_is_supported_voltage(host->vmmc, 1700000,
>> +                     1950000);
>
> We should really add a regulator_is_supported_voltage_tol...  let me
> just do that.
