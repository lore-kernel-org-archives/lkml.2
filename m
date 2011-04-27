Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758410Ab1D0LIx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 07:08:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48941 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757000Ab1D0LIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 07:08:52 -0400
Date: Wed, 27 Apr 2011 12:08:48 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Graeme Gregory <gg@slimlogic.co.uk>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com, balbi@ti.com, lrg@slimlogic.co.uk
Subject: Re: [PATCH 3/4] REGULATOR: TWL6025: add support to twl-regulator
Message-ID: <20110427110848.GB31952@opensource.wolfsonmicro.com>
References: <1303897191-14792-1-git-send-email-gg@slimlogic.co.uk>
 <1303897191-14792-4-git-send-email-gg@slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303897191-14792-4-git-send-email-gg@slimlogic.co.uk>
X-Cookie: Q:	Are we not men?
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 10:39:50AM +0100, Graeme Gregory wrote:

> +	switch (info->flags) {
> +	case 0:
> +		if (index == 0)
> +			voltage = 0;
> +		else if (index < 58)
> +			voltage = (600000 + (12500 * (index - 1)));
> +		else if (index == 58)
> +			voltage = 1350 * 1000;
> +		else if (index == 59)
> +			voltage = 1500 * 1000;
> +		else if (index == 60)
> +			voltage = 1800 * 1000;
> +		else if (index == 61)
> +			voltage = 1900 * 1000;
> +		else if (index == 62)
> +			voltage = 2100 * 1000;

This reads like a switch statement with a default: case to me.

> +static int twl6030dcdc_get_voltage(struct regulator_dev *rdev)
> +{
> +	struct twlreg_info	*info = rdev_get_drvdata(rdev);
> +	int		vsel = twlreg_read(info, TWL_MODULE_PM_RECEIVER,
> +							VREG_VOLTAGE_DCDC);
> +	int voltage = 0;
> +
> +	if (vsel < 0)
> +		return vsel;
> +	switch (info->flags) {

This should just call list_voltage() to do the mapping into a voltage or
better yet should be converted into a get_voltage_sel() which will mean
that the core can call list_voltage() for you.  Either way you save
duplicating the code to map from selector to voltage.
