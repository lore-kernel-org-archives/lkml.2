Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab1LGIu0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 03:50:26 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52571 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954Ab1LGIuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 03:50:25 -0500
Date: Wed, 7 Dec 2011 08:49:58 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Josh Wu <josh.wu@atmel.com>
Cc: g.liakhovetski@gmx.de, linux-media@vger.kernel.org,
        nicolas.ferre@atmel.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] [media] V4L: atmel-isi: add code to enable/disable
	ISI_MCK clock
Message-ID: <20111207084958.GA14542@n2100.arm.linux.org.uk>
References: <1322647604-30662-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322647604-30662-1-git-send-email-josh.wu@atmel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 06:06:43PM +0800, Josh Wu wrote:
> +	/* Get ISI_MCK, provided by programmable clock or external clock */
> +	isi->mck = clk_get(dev, "isi_mck");
> +	if (IS_ERR_OR_NULL(isi->mck)) {

This should be IS_ERR()

> +		dev_err(dev, "Failed to get isi_mck\n");
> +		ret = isi->mck ? PTR_ERR(isi->mck) : -EINVAL;

		ret = PTR_ERR(isi->mck);
