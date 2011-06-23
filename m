Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758728Ab1FWBZk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 21:25:40 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:20810 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758643Ab1FWBZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 21:25:39 -0400
X-AuditID: cbfee61a-b7c59ae000003b70-48-4e02961122dd
Date: Thu, 23 Jun 2011 10:25:37 +0900
From: Sangbeom Kim <sbkim73@samsung.com>
Subject: RE: [PATCH 3/3] mfd: Add I2C control support for S5M8751
In-reply-to: <20110622125050.GE23666@sirena.org.uk>
To: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org
Message-id: <017201cc3144$74e343d0$5ea9cb70$@com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: Acww2wXKI/D3IUq7RcG0G8AIBklNIAAZ/rNQ
References: <1308722037-6966-1-git-send-email-sbkim73@samsung.com>
 <1308722037-6966-4-git-send-email-sbkim73@samsung.com>
 <20110622125050.GE23666@sirena.org.uk>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 09:51:57PM +0900, Mark Brown wrote:
> If the device doesn't support SPI this could just as well be merged into
> the main driver - the reason for splitting with devices that support
> both is that it gives more flexibility with what gets built into the
> core kernel when both APIs are enabled.

Thank for your comment,
We have a few PMIC (S5M8751, S5M8752 and others).
They have different features. And Each one will have separate core file.
But i2c interface is same.
So, I try to separate i2s code.
I would modify prefix like s5m87xx.

> > +static int s5m8751_i2c_read_device(struct s5m8751 *s5m8751, uint8_t
reg,
> > +					uint8_t *val)
> > +{
> > +	int ret;
> > +	ret = i2c_smbus_read_byte_data(s5m8751->i2c_client, reg);
> > +	if (ret < 0) {
> > +		dev_err(s5m8751->dev, "failed reading at 0x%02x\n", reg);
> > +		return ret;
> > +	}
> > +	*val = (uint8_t)ret;
> 
> Why is this case required?

I want pass the read value by val

Thanks and regards,
SB Kim

