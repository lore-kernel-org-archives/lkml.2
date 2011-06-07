Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809Ab1FGNqJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 09:46:09 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:60768 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200Ab1FGNqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 09:46:07 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4DEE2D7D.6070506@cam.ac.uk>
Date: Tue, 07 Jun 2011 14:54:05 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110509 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Ben Dooks <ben-i2c@fluff.org>
CC: anish <anish198519851985@gmail.com>, gregkh@suse.de,
        manuel.stahl@iis.fraunhofer.de, lucas.demarchi@profusion.mobi,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, Linux I2C <linux-i2c@vger.kernel.org>
Subject: Re: [PATCH] staging iio: Replace kmalloc with local variable
References: <1307450354.1516.23.camel@anish-desktop> <4DEE20E7.4020008@cam.ac.uk> <20110607134135.GD15795@trinity.fluff.org>
In-Reply-To: <20110607134135.GD15795@trinity.fluff.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/11 14:41, Ben Dooks wrote:
> On Tue, Jun 07, 2011 at 02:00:23PM +0100, Jonathan Cameron wrote:
>> On 06/07/11 13:39, anish wrote:
>>> From: anish kumar <anish198519851985@gmail.com>
>>>
>>> replaced kmalloc with local variable as I2C(in this case) doesn't require
>>> kmalloc memory it can do with stack memory.
>> I've cc'd linux-i2c just to check I'm right about the whole i2c doesn't need
>> dma safe buffers bit...
> 
> No, it is down to the i2c driver, and from recollection dma from stack is
> not recommended, due to things like cache line alignment. Please do not
> do this.
Then lets drop this.  Sorry Anish, seems I led you down the garden path.
I'll check all my i2c drivers don't do this...
>  
>>> Signed-off-by: anish kumar <anish198519851985@gmail.com>
>> Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
>>> ---
>>>  drivers/staging/iio/adc/max1363_core.c |    5 +----
>>>  1 files changed, 1 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/drivers/staging/iio/adc/max1363_core.c b/drivers/staging/iio/adc/max1363_core.c
>>> index 1037087..9462230 100644
>>> --- a/drivers/staging/iio/adc/max1363_core.c
>>> +++ b/drivers/staging/iio/adc/max1363_core.c
>>> @@ -207,15 +207,12 @@ static int max1363_write_basic_config(struct i2c_client *client,
>>>  				      unsigned char d2)
>>>  {
>>>  	int ret;
>>> -	u8 *tx_buf = kmalloc(2, GFP_KERNEL);
>>> +	u8 tx_buf[2];
>>>  
>>> -	if (!tx_buf)
>>> -		return -ENOMEM;
>>>  	tx_buf[0] = d1;
>>>  	tx_buf[1] = d2;
>>>  
>>>  	ret = i2c_master_send(client, tx_buf, 2);
>>> -	kfree(tx_buf);
>>>  
>>>  	return (ret > 0) ? 0 : ret;
>>>  }
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-i2c" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

