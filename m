Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab2C0B3h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 21:29:37 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:4730 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326Ab2C0B3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 21:29:35 -0400
Message-ID: <4F7117FD.7000700@cavium.com>
Date: Mon, 26 Mar 2012 18:29:33 -0700
From: David Daney <david.daney@cavium.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: David Daney <ddaney.cavm@gmail.com>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>
Subject: Re: [PATCH 1/5] i2c: Convert i2c-octeon.c to use device tree.
References: <1332808075-8333-1-git-send-email-ddaney.cavm@gmail.com> <1332808075-8333-2-git-send-email-ddaney.cavm@gmail.com> <4F7115FA.6080507@gmail.com>
In-Reply-To: <4F7115FA.6080507@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Mar 2012 01:29:14.0552 (UTC) FILETIME=[0511CB80:01CD0BB9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2012 06:20 PM, Rob Herring wrote:
[...]
>> ---
>>
>> Should probably go via Ralf's linux-mips.org tree.
>>
>>   arch/mips/cavium-octeon/octeon-irq.c      |    2 -
>>   arch/mips/cavium-octeon/octeon-platform.c |   84 -------------------------
>>   arch/mips/include/asm/octeon/octeon.h     |    5 --
>>   drivers/i2c/busses/i2c-octeon.c           |   94 ++++++++++++++++-------------
>>   4 files changed, 52 insertions(+), 133 deletions(-)
>
> snip
>
>>
>> -	if (i2c_data == NULL) {
>> -		dev_err(i2c->dev, "no I2C frequency data\n");
>> +	/*
>> +	 * "clock-rate" is a legacy binding, the official binding is
>> +	 * "clock-frequency".  Try the official one first and then
>> +	 * fall back if it doesn't exist.
>> +	 */
>> +	data = of_get_property(pdev->dev.of_node, "clock-frequency",&len);
>> +	if (!data || len != sizeof(*data))
>> +		data = of_get_property(pdev->dev.of_node, "clock-rate",&len);
>> +	if (data&&  len == sizeof(*data)) {
>> +		i2c->twsi_freq = be32_to_cpup(data);
>
> Can't you use of_property_read_u32?

I will investigate, and use it if possible.

>
> Does the legacy binding really exist as DT support is new?
>

Yes, unfortunately some bootloaders escaped into the wild with the 
"clock-rate" binding.

> Otherwise,
>
> Acked-by: Rob Herring<rob.herring@calxeda.com>
>

Thanks,

