Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850Ab1LLPMa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 10:12:30 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:57774 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952Ab1LLPM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 10:12:29 -0500
X-Greylist: delayed 501 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Dec 2011 10:12:29 EST
Message-ID: <4EE617E3.3050201@slimlogic.co.uk>
Date: Mon, 12 Dec 2011 09:04:03 -0600
From: Graeme Gregory <gg@slimlogic.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: Marcus Folkesson <marcus.folkesson@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: tps65910: Handle clear-mask correctly
References: <marcus.folkesson@gmail.com> <1321969191-8604-1-git-send-email-marcus.folkesson@gmail.com> <1321969191-8604-2-git-send-email-marcus.folkesson@gmail.com> <20111212143043.GF13952@sortiz-mobl>
In-Reply-To: <20111212143043.GF13952@sortiz-mobl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I missed the original mail, but yes it looks good to me please push.

Graeme

On 12/12/11 08:30, Samuel Ortiz wrote:
> Hi Marcus,
>
> On Tue, Nov 22, 2011 at 02:39:51PM +0100, Marcus Folkesson wrote:
>> The function is not actually cleaing the bitmask.
> This looks like a valid fix, and all the tps65910_clear_bits() callers seem to
> expect that behaviour. Graeme, I'm going to try to push this one for 3.2,
> unless you object to it.
>
> Cheers,
> Samuel.
>
>> Signed-off-by: Marcus Folkesson<marcus.folkesson@gmail.com>
>> ---
>>   drivers/mfd/tps65910.c |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
>> index 6f5b8cf..c1da84b 100644
>> --- a/drivers/mfd/tps65910.c
>> +++ b/drivers/mfd/tps65910.c
>> @@ -120,7 +120,7 @@ int tps65910_clear_bits(struct tps65910 *tps65910, u8 reg, u8 mask)
>>   		goto out;
>>   	}
>>
>> -	data&= mask;
>> +	data&= ~mask;
>>   	err = tps65910_i2c_write(tps65910, reg, 1,&data);
>>   	if (err)
>>   		dev_err(tps65910->dev, "write to reg %x failed\n", reg);
>> -- 
>> 1.7.5.4
>>

