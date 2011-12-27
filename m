Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656Ab1L0KwL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 05:52:11 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44877 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753371Ab1L0KwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 05:52:07 -0500
Date: Tue, 27 Dec 2011 10:52:03 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, eric.miao@linaro.org,
        Nancy Chen <Nancy.Chen@freescale.com>, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH v3] Regulator: Add Anatop regulator driver
Message-ID: <20111227105203.GE2870@opensource.wolfsonmicro.com>
References: <1324458211-1612-1-git-send-email-paul.liu@linaro.org>
 <1324980994-18462-1-git-send-email-paul.liu@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324980994-18462-1-git-send-email-paul.liu@linaro.org>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 27, 2011 at 06:16:34PM +0800, Ying-Chun Liu (PaulLiu) wrote:

> +	initdata = pdev->dev.platform_data;
> +	sreg = initdata->driver_data;
> +
> +	spin_lock_init(&sreg->lock);

You don't actually appear to use this, though it looks like you need to
do something to protect against simultaneous access to the registers.

> +struct anatop_regulator {
> +       struct regulator_desc regulator;
> +       struct anatop_regulator *parent;
> +       struct anatop_regulator_data *rdata;
> +       struct completion done;
> +
> +       spinlock_t         lock;
> +       struct notifier_block nb;

You aren't using half the things in this structure.
