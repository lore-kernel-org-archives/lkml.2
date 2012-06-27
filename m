Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152Ab2F0MN3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 08:13:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9131 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756761Ab2F0MN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 08:13:27 -0400
Message-ID: <4FEAF8E0.3080307@redhat.com>
Date: Wed, 27 Jun 2012 09:13:20 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH v3] edac: add support for Calxeda highbank memory controller
References: <1339468334-9927-3-git-send-email-robherring2@gmail.com> <1339606915-7521-1-git-send-email-robherring2@gmail.com> <4FE9BCF5.4090109@gmail.com>
In-Reply-To: <4FE9BCF5.4090109@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 26-06-2012 10:45, Rob Herring escreveu:
> Mauro,
> 
> On 06/13/2012 12:01 PM, Rob Herring wrote:
>> From: Rob Herring <rob.herring@calxeda.com>
>>
>> Add support for memory controller on Calxeda Highbank platforms. Highbank
>> platforms support a single 4GB mini-DIMM with 1-bit correction and 2-bit
>> detection.
>>
>> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
>> ---
>> v3: fix compile when EDAC_DEBUG is disabled
> 
> Ping. linux-next is broken for highbank without this fix.

Patch replaced and merged on my trees (with a minor change, see below).

-next should likely get the fix tomorrow.

Thanks,
Mauro.

>>   .../devicetree/bindings/arm/calxeda/mem-ctrlr.txt  |   17 ++
>>   arch/arm/boot/dts/highbank.dts                     |    6 +
>>   drivers/edac/Kconfig                               |    9 +-
>>   drivers/edac/Makefile                              |    2 +
>>   drivers/edac/highbank_mc_edac.c                    |  264 ++++++++++++++++++++
>>   5 files changed, 297 insertions(+), 1 deletion(-)
>>   create mode 100644 Documentation/devicetree/bindings/arm/calxeda/mem-ctrlr.txt
>>   create mode 100644 drivers/edac/highbank_mc_edac.c
>>
>> diff --git a/Documentation/devicetree/bindings/arm/calxeda/mem-ctrlr.txt b/Documentation/devicetree/bindings/arm/calxeda/mem-ctrlr.txt
>> new file mode 100644
>> index 0000000..5c74a0b
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/arm/calxeda/mem-ctrlr.txt
>> @@ -0,0 +1,17 @@
>> +Calxeda DDR memory controller
>> +
>> +Properties:
>> +- compatible : Should be "calxeda,hb-ddr-ctrl"
>> +- reg : Address and size for DDR controller registers.
>> +- interrupts : Interrupt for DDR controller.
>> +
>> +Example:
>> +
>> +	memory-controller@fff00000 {
>> +		compatible = "calxeda,hb-ddr-ctrl";
>> +		reg = <0xfff00000 0x1000>;
>> +		interrupts = <0 91 4>;
>> +	};
>> +
>> +
>> +

There are some extra blank likes at the end of this file. I removed them.
