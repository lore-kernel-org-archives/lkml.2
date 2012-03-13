Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758331Ab2CMFfL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 01:35:11 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10946 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab2CMFfJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 01:35:09 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 12 Mar 2012 22:35:04 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Chanwoo Choi <cw00.choi@samsung.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
Date: Tue, 13 Mar 2012 11:05:01 +0530
Subject: RE: [RESEND PATCH 1/2] MFD: MAX77693: add MAX77693 MFD driver
Thread-Topic: [RESEND PATCH 1/2] MFD: MAX77693: add MAX77693 MFD driver
Thread-Index: Ac0A2knKHGLZVEU0REOWKzbgryP36QAAI5Ag
Message-ID: <D958900912E20642BCBC71664EFECE3E6DD2912D02@BGMAIL02.nvidia.com>
References: <4F5EDB01.9070308@samsung.com>
In-Reply-To: <4F5EDB01.9070308@samsung.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Why don't you make use of regmap for all i2c read/ write operations?

> +int max77693_read_reg(struct i2c_client *i2c, u8 reg, u8 *dest)
> +{
> +	struct max77693_dev *max77693 = i2c_get_clientdata(i2c);
> +	int ret;
> +
> +	mutex_lock(&max77693->iolock);
> +	ret = i2c_smbus_read_byte_data(i2c, reg);
> +	mutex_unlock(&max77693->iolock);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret &= 0xff;
> +	*dest = ret;
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(max77693_read_reg);
> +
