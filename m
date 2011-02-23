Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574Ab1BWAcG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 19:32:06 -0500
Received: from www.wytron.com.tw ([211.75.82.101]:60078 "EHLO
	www.wytron.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab1BWAcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 19:32:03 -0500
Message-ID: <4D645578.3020906@wytron.com.tw>
Date: Wed, 23 Feb 2011 08:31:52 +0800
From: Thomas Chou <thomas@wytron.com.tw>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Ben Dooks <ben-i2c@fluff.org>
CC: Grant Likely <grant.likely@secretlab.ca>, Ben Dooks <ben-linux@fluff.org>,
        linux-kernel@vger.kernel.org, nios2-dev@sopc.et.ntust.edu.tw,
        devicetree-discuss@lists.ozlabs.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH] i2c-ocores: register devices on child nodes
References: <1297306314-11483-1-git-send-email-thomas@wytron.com.tw> <20110223001252.GT15795@trinity.fluff.org>
In-Reply-To: <20110223001252.GT15795@trinity.fluff.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.250
X-SA-Exim-Mail-From: thomas@wytron.com.tw
X-SA-Exim-Scanned: No (on www.wytron.com.tw); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2011 08:12 AM, Ben Dooks wrote:
> On Thu, Feb 10, 2011 at 10:51:54AM +0800, Thomas Chou wrote:
>> This patch registers devices on the devicetree child nodes to the bus.
>> Also removes one trailing whitespace.
>
> Is this required as an urgent fix, or can it queue for next merge window?

It is not urgent. An it is fine to queue it for next merge window.

- Thomas

>
>> Signed-off-by: Thomas Chou<thomas@wytron.com.tw>
>> ---
>>   drivers/i2c/busses/i2c-ocores.c |    6 +++++-
>>   1 files changed, 5 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/i2c/busses/i2c-ocores.c b/drivers/i2c/busses/i2c-ocores.c
>> index ef3bcb1..c63838f 100644
>> --- a/drivers/i2c/busses/i2c-ocores.c
>> +++ b/drivers/i2c/busses/i2c-ocores.c
>> @@ -18,7 +18,7 @@
>>    * - interrupts      : interrupt number
>>    * - regstep         : size of device registers in bytes
>>    * - clock-frequency : frequency of bus clock in Hz
>> - *
>> + *
>>    * Example:
>>    *
>>    *  i2c0: ocores@a0000000 {
>> @@ -55,6 +55,7 @@
>>   #include<linux/i2c-ocores.h>
>>   #include<linux/slab.h>
>>   #include<linux/io.h>
>> +#include<linux/of_i2c.h>
>>
>>   struct ocores_i2c {
>>   	void __iomem *base;
>> @@ -347,6 +348,9 @@ static int __devinit ocores_i2c_probe(struct platform_device *pdev)
>>   			i2c_new_device(&i2c->adap, pdata->devices + i);
>>   	}
>>
>> +	/* Now register all the child nodes */
>> +	of_i2c_register_devices(&i2c->adap);
>> +
>>   	return 0;
>>   }
>>
>> --
>> 1.7.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-i2c" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

