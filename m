Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757700Ab1FVMuy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 08:50:54 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58771 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924Ab1FVMux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 08:50:53 -0400
Date: Wed, 22 Jun 2011 13:50:50 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sangbeom Kim <sbkim73@samsung.com>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mfd: Add I2C control support for S5M8751
Message-ID: <20110622125050.GE23666@sirena.org.uk>
References: <1308722037-6966-1-git-send-email-sbkim73@samsung.com> <1308722037-6966-4-git-send-email-sbkim73@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308722037-6966-4-git-send-email-sbkim73@samsung.com>
X-Cookie: Is it clean in other dimensions?
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 02:53:57PM +0900, Sangbeom Kim wrote:
> Implement the I2C control interface for the S5M8751.
> 
> Signed-off-by: Sangbeom Kim <sbkim73@samsung.com>

If the device doesn't support SPI this could just as well be merged into
the main driver - the reason for splitting with devices that support
both is that it gives more flexibility with what gets built into the
core kernel when both APIs are enabled.

> +static int s5m8751_i2c_read_device(struct s5m8751 *s5m8751, uint8_t reg,
> +					uint8_t *val)
> +{
> +	int ret;
> +	ret = i2c_smbus_read_byte_data(s5m8751->i2c_client, reg);
> +	if (ret < 0) {
> +		dev_err(s5m8751->dev, "failed reading at 0x%02x\n", reg);
> +		return ret;
> +	}
> +	*val = (uint8_t)ret;

Why is this case required?
