Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197Ab1LELkA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 06:40:00 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:4401 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755958Ab1LELj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 06:39:59 -0500
Message-ID: <4EDCAD82.5050006@atmel.com>
Date: Mon, 05 Dec 2011 12:39:46 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: robherring2@gmail.com, devicetree-discuss@lists.ozlabs.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        grant.likely@secretlab.ca, linux-kernel@vger.kernel.org,
        jamie@jamieiles.com
Subject: Re: [PATCH] ARM: at91/net: add macb ethernet controller in 9g45 DT
References: <1322847782-22650-1-git-send-email-nicolas.ferre@atmel.com> <1322848237-23154-1-git-send-email-nicolas.ferre@atmel.com> <20111203055659.GL18533@game.jcrosoft.org>
In-Reply-To: <20111203055659.GL18533@game.jcrosoft.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2011 06:56 AM, Jean-Christophe PLAGNIOL-VILLARD :
> On 18:50 Fri 02 Dec     , Nicolas Ferre wrote:
>> Add the Cadence macb ethernet controller in at91sam9g45 .dtsi and
>> enable it in at91sam9m10g45ek board device tree file.
>>
>> Signed-off-by: Nicolas Ferre<nicolas.ferre@atmel.com>
>> ---
>>   arch/arm/boot/dts/at91sam9g45.dtsi     |    7 +++++++
>>   arch/arm/boot/dts/at91sam9m10g45ek.dts |    6 ++++++
>>   2 files changed, 13 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/arm/boot/dts/at91sam9g45.dtsi b/arch/arm/boot/dts/at91sam9g45.dtsi
>> index e89b1d7..67f94d3 100644
>> --- a/arch/arm/boot/dts/at91sam9g45.dtsi
>> +++ b/arch/arm/boot/dts/at91sam9g45.dtsi
>> @@ -101,6 +101,13 @@
>>   				atmel,use-dma-tx;
>>   				status = "disabled";
>>   			};
>> +
>> +			macb0: ethernet@fffbc000 {
>> +				compatible = "cdns,at32ap7000-macb", "cdns,macb";
>> +				reg =<0xfffbc000 0x100>;
>> +				interrupts =<25 4>;
> why?

It is the new AIC specification that was reworked in this patch:
https://lkml.org/lkml/2011/12/1/238

>> +				status = "disabled";
>> +			};
>>   		};
>>   	};
>>   };
>> diff --git a/arch/arm/boot/dts/at91sam9m10g45ek.dts b/arch/arm/boot/dts/at91sam9m10g45ek.dts
>> index 85b34f5..17377a2 100644
>> --- a/arch/arm/boot/dts/at91sam9m10g45ek.dts
>> +++ b/arch/arm/boot/dts/at91sam9m10g45ek.dts
>> @@ -30,6 +30,12 @@
>>   			usart1: serial@fff90000 {
>>   				status = "okay";
>>   			};
>> +
>> +			macb0: ethernet@fffbc000 {
>> +				local-mac-address = [3a 0e 03 04 05 06];
> please drop this is not supposed to be in the dts but updated for each board

Yes, sure: I kept in because it was allowing me to test. But for sure, 
this should go away...

Bye,
-- 
Nicolas Ferre
