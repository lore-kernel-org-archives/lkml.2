Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615Ab0FCXuq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 19:50:46 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:35682 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab0FCXup convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 19:50:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lz8SLXhUGsCPtNNAwuEmRDZoKT+oXxG2S1oH5z6Ul4cIJ4ua29/AWSVctO60d9Mku0
         jp6x1IH0xP97t8xWAiNiixoosCaPLp7fNDWak01gcshXzA+BGHFblIvz4zSIQyLDCpxo
         OzmtoGKC9VWV0aUuyxiBCrj9hsuX8XNc9cess=
MIME-Version: 1.0
In-Reply-To: <AANLkTilQQrWX-wUiw_835x6KxRM_9xAV_z58Fu0IgqY2@mail.gmail.com>
References: <AANLkTinmBxzM4IEgrY6gqokDhLJDrVyKd0cu75VaFR8Q@mail.gmail.com>
	<4C04496E.3000303@gmail.com>
	<AANLkTil6y3F1RDZaNwKS1FZB_Nrl_meFxIR2XzMoqCO7@mail.gmail.com>
	<AANLkTilQQrWX-wUiw_835x6KxRM_9xAV_z58Fu0IgqY2@mail.gmail.com>
Date: Thu, 3 Jun 2010 18:50:44 -0500
Message-ID: <AANLkTil9MQq-22Q8_0-J49B56EFUlTkUf5o4Lpd5BVum@mail.gmail.com>
Subject: Re: resource piix4_smbus conflicts with ACPI region SMRG
From: Richard Tillmore <rtillmore@gmail.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, 2010 at 10:13 PM, Robert Hancock wrote:
> On Mon, May 31, 2010 at 8:36 PM, Richard wrote:
>> On Mon, May 31, 2010 at 6:42 PM, Robert Hancock wrote:
>>> On 05/31/2010 04:12 PM, Richard wrote:
>>>>
>>>> I upgraded to 2.6.34-rc6 and noticed a few new messages in dmesg.  I
>>>> then installed 2.6.34 and the messages remain.
<snip>
>>>> ACPI: resource piix4_smbus [io  0x0440-0x0447] conflicts with ACPI
>>>> region SMRG [??? 0x00000440-0x0000044f flags 0x47]
>>>> ACPI: If an ACPI driver is available for this device, you should use
>>>> it instead of the native driver
>>>>
>>>> The system is a Tyan Tiger S1832 motherboard with a P3 850Mhz
>>>> processor running the latest bios.  Everything appears to work
>>>> properly so I am unsure what the messages mean beyond the obvious.  I
>>>> did a little research and was wondering if this is related to the no
>>>> bootmem patches.  I have:
>>>
>>> Unless you need to use anything on SMBus (hardware sensors, essentially) you
>>> don't have to worry about that one. It means that the kernel has detected
>>> that the BIOS may potentially access the SMBus controller which may conflict
>>> with usage of the controller from within the OS.
>>
>> I do use the lm78 sensor driver:
>> lm78: Found an LM79 chip at 0x290
>> and the Xsensors seem to work, the voltages and fan speeds change.
>>
>> But you are correct the lm75 driver isn't loading so I am not getting
>> my cpu temperature.
>>
>> In 2.6.30.9 I have:
>> Driver `lm78'
>>  Detects correctly:
>>  * Bus `SMBus PIIX4 adapter at 0440'
>>    Busdriver `i2c-piix4', I2C address 0x2d
>>    ISA bus, address 0x290
>>    Chip `National Semiconductor LM79' (confidence: 6)
>>
>> Driver `lm75'
>>  Detects correctly:
>>  * Bus `SMBus PIIX4 adapter at 0440'
>>    Busdriver `i2c-piix4', I2C address 0x4c
>>    Chip `National Semiconductor LM75' (confidence: 6)
>>  * Bus `SMBus PIIX4 adapter at 0440'
>>    Busdriver `i2c-piix4', I2C address 0x4d
>>    Chip `National Semiconductor LM75' (confidence: 6)
>>
>> In 2.6.34 I get:
>> Driver `lm78'
>>  Detects correctly:
>>  * ISA bus, address 0x290
>>    Chip `National Semiconductor LM79' (confidence: 6)
>>
>> So this is a regression.
>
> You should be able to use acpi_enforce_resources=lax on the kernel
> command line to allow the driver to load. The problem is that the
> kernel can't tell if it's safe to allow a driver to access that
> hardware since it may conflict with BIOS access (in some cases this
> can cause serious problems like system overheating or spurious thermal
> shutdowns if the BIOS also accesses the device to perform thermal
> management) and so the default is to not allow it.

I booted with acpi_enforce_resources=lax and I now can get my CPU
temperature.  So is my having to add acpi_enforce_resources=lax an
effect of ACPI changes or bootmem changes?

Thanks,
Rich
