Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758709Ab1FWDNt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 23:13:49 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:65427 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758190Ab1FWDNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 23:13:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=QySaTfwivYN5jY/BBbej6qM8YR+SBW/2ufW6PgRV3AZ4hiwJYTOs8OkRmL5fi6gsw6
         F6OGXzaCmycQVQ8beP/XrsRL5v9HYL5Mx9bPbaggQxsbts1BgOCEcK/YjU3ewUYqN6LB
         +TDLzwW9IAzz60DPlNYne/QD+SqkYPcEoN0HY=
Message-ID: <4E02AF69.2090800@gmail.com>
Date: Wed, 22 Jun 2011 20:13:45 -0700
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc13 Thunderbird/3.1.10
MIME-Version: 1.0
To: Feng Tang <feng.tang@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>
Subject: Re: [PATCH 11/11] spi-dw: remove noop else clause
References: <1308794413-11069-1-git-send-email-dirk.brandewie@gmail.com>	<1308794413-11069-12-git-send-email-dirk.brandewie@gmail.com> <20110623104756.1d1c8da4@feng-i7>
In-Reply-To: <20110623104756.1d1c8da4@feng-i7>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2011 07:47 PM, Feng Tang wrote:
> On Thu, 23 Jun 2011 10:00:13 +0800
> "dirk.brandewie@gmail.com"<dirk.brandewie@gmail.com>  wrote:
>
>> From: Dirk Brandewie<dirk.brandewie@gmail.com>
>>
>> The value of spi->bits_per_word is checked on function entry to be 8
>> or 16.  The else clause has no meaning since it can never be reached.
>>
>> Signed-off-by: Dirk Brandewie<dirk.brandewie@gmail.com>
>> ---
>>   drivers/spi/spi-dw.c |    9 +++------
>>   1 files changed, 3 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/spi/spi-dw.c b/drivers/spi/spi-dw.c
>> index 7b3f607..5ddd45f 100644
>> --- a/drivers/spi/spi-dw.c
>> +++ b/drivers/spi/spi-dw.c
>> @@ -667,17 +667,14 @@ static int spi_dw_setup(struct spi_device *spi)
>>   		chip->enable_dma = chip_info->enable_dma;
>>   	}
>>
>> -	if (spi->bits_per_word<= 8) {
>> +	if (spi->bits_per_word == 8) {
>>   		chip->n_bytes = 1;
>>   		chip->dma_width = 1;
>> -	} else if (spi->bits_per_word<= 16) {
>> +	} else if (spi->bits_per_word == 16) {
>>   		chip->n_bytes = 2;
>>   		chip->dma_width = 2;
>> -	} else {
>> -		/* Never take>16b case for DW SPIC */
>> -		dev_err(&spi->dev, "invalid wordsize\n");
>> -		return -EINVAL;
>>   	}
>
> These "else" case is used to ban the slave spi devices which
> try to use 32 bits per word mode. This is like to tell those
> spi devices with 32 bpw capability "we don't support 32b, pls
> change"

The function has the prerequisite code:
	if (spi->bits_per_word != 8 && spi->bits_per_word != 16)
		return -EINVAL;

at the begining of the function so we will never be able to reach the else 
clause that is being removed.

>
>> +
>>   	chip->bits_per_word = spi->bits_per_word;
>>
>>   	chip->speed_hz = spi->max_speed_hz;

