Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab2EAH4Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 03:56:16 -0400
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:58857 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584Ab2EAH4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 03:56:15 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4F9F9711.1010904@cam.ac.uk>
Date: Tue, 01 May 2012 08:56:01 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: joseph daniel <josephdanielwalter@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/iio/meter: fix the coding style problem
References: <1335813977-8096-1-git-send-email-josephdanielwalter@gmail.com> <4F9EEFB2.8030201@metafoo.de>
In-Reply-To: <4F9EEFB2.8030201@metafoo.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/30/2012 9:01 PM, Lars-Peter Clausen wrote:
> On 04/30/2012 09:26 PM, joseph daniel wrote:
>> Signed-off-by: joseph daniel<josephdanielwalter@gmail.com>
>> ---
>> Hi Lars,
>> 	Thanks for review. how about the below change?
>>   drivers/staging/iio/meter/ade7854-i2c.c |    6 +++++-
>>   1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/staging/iio/meter/ade7854-i2c.c b/drivers/staging/iio/meter/ade7854-i2c.c
>> index 1e1faa0..52bdb05 100644
>> --- a/drivers/staging/iio/meter/ade7854-i2c.c
>> +++ b/drivers/staging/iio/meter/ade7854-i2c.c
>> @@ -181,6 +181,7 @@ static int ade7854_i2c_read_reg_32(struct device *dev,
>>   {
>>   	struct iio_dev *indio_dev = dev_get_drvdata(dev);
>>   	struct ade7854_state *st = iio_priv(indio_dev);
>> +	uint32_t value;
>>   	int ret;
>>
>>   	mutex_lock(&st->buf_lock);
>> @@ -195,7 +196,10 @@ static int ade7854_i2c_read_reg_32(struct device *dev,
>>   	if (ret)
>>   		goto out;
>>
>> -	*val = (st->rx[0]<<  24) | (st->rx[1]<<  16) | (st->rx[2]<<  8) | st->rx[3];
>> +	memcpy(&value, st->rx, sizeof(uint32_t));
>> +
> Uhm, yes, you are right st->rx is unaligned. The memcpy is not necessary though
> if you use get_unaligned_be32. Sorry for the pointer to the wrong function.
Or we could just force the alignment of st->rx? Might not be worth 
bothering.
>
> Btw. there are a few other locations in this driver which could use the
> put_unaligned_be* and get_unaligned_be* functions. Would be great if you could
> convert these as well.
>
>> +	*val = be32_to_cpu(value);
>> +
>>   out:
>>   	mutex_unlock(&st->buf_lock);
>>   	return ret;

