Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551Ab1IEKd7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 06:33:59 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39441 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab1IEKdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 06:33:55 -0400
Date: Mon, 5 Sep 2011 11:33:39 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Josh Wu <josh.wu@atmel.com>
Cc: g.liakhovetski@gmx.de, linux-media@vger.kernel.org, plagnioj@jcrosoft.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] [media] at91: add code to initialize and manage the
	ISI_MCK for Atmel ISI driver.
Message-ID: <20110905103339.GG6619@n2100.arm.linux.org.uk>
References: <1315218593-10822-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315218593-10822-1-git-send-email-josh.wu@atmel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 05, 2011 at 06:29:53PM +0800, Josh Wu wrote:
> +static int initialize_mck(struct atmel_isi *isi,
> +			struct isi_platform_data *pdata)
> +{
> +	int ret;
> +	struct clk *pck_parent;
> +
> +	if (!strlen(pdata->pck_name) || !strlen(pdata->pck_parent_name))
> +		return -EINVAL;
> +
> +	/* ISI_MCK is provided by PCK clock */
> +	isi->mck = clk_get(NULL, pdata->pck_name);

No, this is not how you use the clk API.  You do not pass clock names via
platform data.

You pass clk_get() the struct device.  You then pass clk_get() a
_connection id_ on that _device_ if you have more than one struct clk
associated with the _device_.  You then use clkdev to associate the
struct device plus the connection id with the appropriate struct clk.
