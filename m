Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab0LOUMA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 15:12:00 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:40777 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755271Ab0LOUL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 15:11:57 -0500
Message-ID: <4D0920DD.3080306@oracle.com>
Date: Wed, 15 Dec 2010 12:11:09 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH] GPIO_SCH and I2C_SCH: select MFD_SUPPORT to eliminate
  kconfig warnings
References: <20101214162656.b8550c70.randy.dunlap@oracle.com> <20101215101541.5952780f@endymion.delvare>
In-Reply-To: <20101215101541.5952780f@endymion.delvare>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/10 01:15, Jean Delvare wrote:
> Hi Randy,
> 
> On Tue, 14 Dec 2010 16:26:56 -0800, Randy Dunlap wrote:
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> I2C_ISCH and GPIO_SCH need to select MFD_SUPPORT so that the
>> dependency tree hierarchy is satisfied.  This eliminates the
>> kconfig warning:
>>
>> warning: (I2C_ISCH && I2C && PCI || GPIO_SCH && GPIOLIB && PCI) selects LPC_SCH which has unmet direct dependencies (MFD_SUPPORT && PCI)
>>
>> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
>> Cc: linux-i2c@vger.kernel.org
>> ---
>>  drivers/gpio/Kconfig       |    1 +
>>  drivers/i2c/busses/Kconfig |    1 +
>>  2 files changed, 2 insertions(+)
>>
>> --- lnx-2637-rc4.orig/drivers/gpio/Kconfig
>> +++ lnx-2637-rc4/drivers/gpio/Kconfig
>> @@ -102,6 +102,7 @@ config GPIO_VR41XX
>>  config GPIO_SCH
>>  	tristate "Intel SCH GPIO"
>>  	depends on GPIOLIB && PCI
>> +	select MFD_SUPPORT
>>  	select MFD_CORE
>>  	select LPC_SCH
>>  	help
>> --- lnx-2637-rc4.orig/drivers/i2c/busses/Kconfig
>> +++ lnx-2637-rc4/drivers/i2c/busses/Kconfig
>> @@ -107,6 +107,7 @@ config I2C_I801
>>  config I2C_ISCH
>>  	tristate "Intel SCH SMBus 1.0"
>>  	depends on PCI
>> +	select MFD_SUPPORT
>>  	select MFD_CORE
>>  	select LPC_SCH
>>  	help
> 
> It seems wrong to have to select both MFD_SUPPORT and MFD_CORE. Can't
> the MFD subsystem be cleaned up so that subdrivers have a single symbol
> to select beyond their own?
> 
> I don't quite get the point of MFD_CORE. MFD_SUPPORT could be made
> tristate, and MFD_CORE dropped (and then MFD_SUPPORT renamed to
> MFD_CORE to minimize the changes.) This is exactly how I2C support is
> implemented, for example.

OK, I'll look into that.  Thanks.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
