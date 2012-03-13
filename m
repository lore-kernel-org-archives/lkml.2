Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759111Ab2CMFja (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 01:39:30 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54198 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759069Ab2CMFjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 01:39:24 -0400
MIME-Version: 1.0
In-Reply-To: <D958900912E20642BCBC71664EFECE3E6DD2912D02@BGMAIL02.nvidia.com>
References: <4F5EDB01.9070308@samsung.com>
	<D958900912E20642BCBC71664EFECE3E6DD2912D02@BGMAIL02.nvidia.com>
Date: Tue, 13 Mar 2012 14:39:23 +0900
X-Google-Sender-Auth: au8EBhoZEFdCGkcgRRwbf6Lid6k
Message-ID: <CAH9JG2VrNCPMHoy5pUyc7nTzv-B7ucXheMy7PBtVUfaebt=yUA@mail.gmail.com>
Subject: Re: [RESEND PATCH 1/2] MFD: MAX77693: add MAX77693 MFD driver
From: Kyungmin Park <kyungmin.park@samsung.com>
To: Venu Byravarasu <vbyravarasu@nvidia.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It's discussed previous time. It's PMIC and very sensitive to system.
So we decide to use legacy way. As regmap is not yet tested. So we
summit the current way and revise it later.

Thank you,
Kyungmin Park

On 3/13/12, Venu Byravarasu <vbyravarasu@nvidia.com> wrote:
> Why don't you make use of regmap for all i2c read/ write operations?
>
>> +int max77693_read_reg(struct i2c_client *i2c, u8 reg, u8 *dest)
>> +{
>> +	struct max77693_dev *max77693 = i2c_get_clientdata(i2c);
>> +	int ret;
>> +
>> +	mutex_lock(&max77693->iolock);
>> +	ret = i2c_smbus_read_byte_data(i2c, reg);
>> +	mutex_unlock(&max77693->iolock);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	ret &= 0xff;
>> +	*dest = ret;
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(max77693_read_reg);
>> +
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
