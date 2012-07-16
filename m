Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab2GPUBQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 16:01:16 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47406 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751721Ab2GPUBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 16:01:12 -0400
Date: Mon, 16 Jul 2012 21:01:11 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        swarren@nvidia.com
Subject: Re: [PATCH V2 1/6] mfd: tps6586x:use devm managed resources
Message-ID: <20120716200110.GD10774@opensource.wolfsonmicro.com>
References: <1342421510-10638-1-git-send-email-ldewangan@nvidia.com>
 <1342421510-10638-2-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342421510-10638-2-git-send-email-ldewangan@nvidia.com>
X-Cookie: You will get what you deserve.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2012 at 12:21:45PM +0530, Laxman Dewangan wrote:

> -	ret = request_threaded_irq(irq, NULL, tps6586x_irq, IRQF_ONESHOT,
> -				   "tps6586x", tps6586x);
> +	ret = devm_request_threaded_irq(tps6586x->dev, irq, NULL, tps6586x_irq,
> +			IRQF_ONESHOT, "tps6586x", tps6586x);

Are you sure this is safe - what guarantees that we can't get an
interrupt while tearing the device down?
