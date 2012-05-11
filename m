Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760075Ab2EKOFi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 10:05:38 -0400
Received: from mga03.intel.com ([143.182.124.21]:24217 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504Ab2EKOFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 10:05:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="98965332"
Date: Fri, 11 May 2012 16:15:08 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [RESEND PATCH v2 1/2] MFD: MAX77693: add MAX77693 MFD driver
Message-ID: <20120511141508.GQ1214@sortiz-mobl>
References: <4F5EDB01.9070308@samsung.com>
 <4F67D86E.30509@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F67D86E.30509@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Choi,

On Tue, Mar 20, 2012 at 10:07:58AM +0900, Chanwoo Choi wrote:
> @@ -0,0 +1,224 @@
> +/*
> + * max77693.c - mfd core driver for the MAX 77693
> + *
> + * Copyright (C) 2011 Samsung Electronics
2012 ?

> +int max77693_read_reg(struct i2c_client *i2c, u8 reg, u8 *dest)
> +{
> +	struct max77693_dev *max77693 = i2c_get_clientdata(i2c);
> +	int ret;
> +
> +	mutex_lock(&max77693->iolock);
> +	ret = i2c_smbus_read_byte_data(i2c, reg);
> +	mutex_unlock(&max77693->iolock);
You don't need this locking as the i2c layer will do it for you.
Also, this definitely look like a good candidate for a regmap API conversion,
I'd appreciate if you could work on that.

> +static struct i2c_driver max77693_i2c_driver = {
> +	.driver = {
> +		   .name = "max77693",
> +		   .owner = THIS_MODULE,
> +	},
> +	.probe = max77693_i2c_probe,
> +	.remove = max77693_i2c_remove,
> +	.id_table = max77693_i2c_id,
> +};
> +
> +static int __init max77693_i2c_init(void)
> +{
> +	return i2c_add_driver(&max77693_i2c_driver);
> +}
> +/* init early so consumer devices can complete system boot */
> +subsys_initcall(max77693_i2c_init);
> +
> +static void __exit max77693_i2c_exit(void)
> +{
> +	i2c_del_driver(&max77693_i2c_driver);
> +}
> +module_exit(max77693_i2c_exit);
You could use module_i2c_driver() here.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
