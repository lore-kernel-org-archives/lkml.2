Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129Ab1L0LgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 06:36:18 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35716 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752317Ab1L0LgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 06:36:17 -0500
Date: Tue, 27 Dec 2011 11:36:12 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Donggeun Kim <dg77.kim@samsung.com>
Cc: linux-pm@vger.kernel.org, len.brown@intel.com, pavel@ucw.cz, rjw@sisk.pl,
        rdunlap@xenotime.net, cbouatmailru@gmail.com, pali.rohar@gmail.com,
        prakity@mavell.com, lars@metafoo.de, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] power: Charger-Manager: add initial
 Charger-Manager driver
Message-ID: <20111227113611.GH2870@opensource.wolfsonmicro.com>
References: <1324979269-2453-1-git-send-email-dg77.kim@samsung.com>
 <1324979269-2453-2-git-send-email-dg77.kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324979269-2453-2-git-send-email-dg77.kim@samsung.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 27, 2011 at 06:47:48PM +0900, Donggeun Kim wrote:

> +		/*
> +		 * Abnormal battery state - Stop charging forcibly,
> +		 * even if charger was enabled at the other places
> +		 */
> +		err = regulator_bulk_disable(desc->num_charger_regulators,
> +					desc->charger_regulators);
> +
> +		for (i = 0; i < desc->num_charger_regulators; i++) {
> +			if (regulator_is_enabled(
> +				    desc->charger_regulators[i].consumer)) {
> +				regulator_force_disable(
> +					desc->charger_regulators[i].consumer);
> +				dev_warn(cm->dev,
> +					"Disable regulator(%s) forcibly.\n",
> +					desc->charger_regulators[i].supply);
> +			}

Just implement a regulator_bulk_force_disable() operation; this is a
totally reasonable thing to want to do and other drivers may have the
same need.  Actually, looking at what you've written here it's totally
sensible and we should probably also roll the attempt to do a normal
disable() into force_disable() - there can't be many situations in which
trying a clean shutdown first isn't the right thing to do.
