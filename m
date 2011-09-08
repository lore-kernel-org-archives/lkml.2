Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab1IHXhM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 19:37:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47540 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754596Ab1IHXhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 19:37:09 -0400
Date: Thu, 8 Sep 2011 09:30:18 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: linux-kernel@vger.kernel.org, Michael.Hennerich@analog.com,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH 2/2] staging:iio:imu:adis16400 regmap introduction.
Message-ID: <20110908163017.GC3098@opensource.wolfsonmicro.com>
References: <1315490964-25718-1-git-send-email-jic23@cam.ac.uk>
 <1315490964-25718-3-git-send-email-jic23@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315490964-25718-3-git-send-email-jic23@cam.ac.uk>
X-Cookie: Avoid reality at all costs.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 08, 2011 at 03:09:24PM +0100, Jonathan Cameron wrote:
> Apply regmap for the basic register reads and writes.
> Note not currently used at all for the mass reads
> that occur in the buffer code.

Looks good, shame adding the register access lists makes the diffstat
grow rather than shrink - a separate patch adding the access maps would
be good for showing the benefits :)

> +	case ADIS16400_DIAG_STAT:
> +		return true;
> +	default:
> +		return 0;

Should use either 1/0 or true/false consistently (probably the latter).

> +static const struct regmap_config adis16400_regmap_config = {
> +	.reg_bits = 8,
> +	.reg_pad_bits = 8,
> +	.val_bits = 16,
> +	.half_write = true,
> +	.writeable_reg = &adis16400_reg_writeable,
> +	.readable_reg = &adis16400_reg_readable,
> +	.precious_reg = &adis16400_reg_precious,
> +	.volatile_reg = &adis16400_reg_volatile,
> +	.max_register = 0x56,
> +	.write_flag_mask = 0x80,
> +	.read_flag_mask = 0,

No need to set things to zero explicitly.

> -
> +	spi->cs_between_transfers = 1;

Guess we need that change to go in first...
