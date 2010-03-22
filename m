Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661Ab0CVWuV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 18:50:21 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:52877 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab0CVWuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 18:50:18 -0400
Message-ID: <4BA7F3E8.6000306@oracle.com>
Date: Mon, 22 Mar 2010 15:49:12 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: "Savoy, Pavan" <pavan_savoy@ti.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6] drivers:misc: Kconfig, Makefile for TI's ST ldisc
References: <1269292756-7469-1-git-send-email-pavan_savoy@ti.com> <1269292756-7469-2-git-send-email-pavan_savoy@ti.com> <1269292756-7469-3-git-send-email-pavan_savoy@ti.com>,<4BA7E4E7.8010005@oracle.com> <19F8576C6E063C45BE387C64729E7394044DB828A4@dbde02.ent.ti.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E7394044DB828A4@dbde02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4BA7F418.006F:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/10 15:37, Savoy, Pavan wrote:
> patch below....
> _______________________________________
> From: Randy Dunlap [randy.dunlap@oracle.com]
> Sent: Tuesday, March 23, 2010 3:15 AM
> To: Savoy, Pavan
> Cc: gregkh@suse.de; alan@lxorguk.ukuu.org.uk; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 2/6] drivers:misc: Kconfig, Makefile for TI's ST ldisc
> 
> On 03/22/10 14:19, pavan_savoy@ti.com wrote:
>> From: Pavan Savoy <pavan_savoy@ti.com>
>>
>> This change adds the Kconfig and Make file for TI's
>> ST line discipline driver and the BlueZ driver for BT
>> core of the TI BT/FM/GPS combo chip.
>>
>> Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
>> ---
>>  drivers/misc/Kconfig        |    1 +
>>  drivers/misc/Makefile       |    1 +
>>  drivers/misc/ti-st/Kconfig  |   24 ++++++++++++++++++++++++
>>  drivers/misc/ti-st/Makefile |    7 +++++++
>>  4 files changed, 33 insertions(+), 0 deletions(-)
>>  create mode 100644 drivers/misc/ti-st/Kconfig
>>  create mode 100644 drivers/misc/ti-st/Makefile
>>
>> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
>> index 625e3a6..c059bca 100644
>> --- a/drivers/misc/Kconfig
>> +++ b/drivers/misc/Kconfig
>> @@ -344,5 +344,6 @@ source "drivers/misc/c2port/Kconfig"
>>  source "drivers/misc/eeprom/Kconfig"
>>  source "drivers/misc/cb710/Kconfig"
>>  source "drivers/misc/iwmc3200top/Kconfig"
>> +source "drivers/misc/ti-st/Kconfig"
>>
>>  endif # MISC_DEVICES
>> diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
>> index c221917..021f282 100644
>> --- a/drivers/misc/Makefile
>> +++ b/drivers/misc/Makefile
>> @@ -30,3 +30,4 @@ obj-$(CONFIG_IWMC3200TOP)      += iwmc3200top/
>>  obj-$(CONFIG_HWLAT_DETECTOR) += hwlat_detector.o
>>  obj-y                                += eeprom/
>>  obj-y                                += cb710/
>> +obj-y                                += ti-st/
>> diff --git a/drivers/misc/ti-st/Kconfig b/drivers/misc/ti-st/Kconfig
>> new file mode 100644
>> index 0000000..18eea1c
>> --- /dev/null
>> +++ b/drivers/misc/ti-st/Kconfig
>> @@ -0,0 +1,24 @@
>> +#
>> +# TI's shared transport line discipline and the protocol
>> +# drivers (BT, FM and GPS)
>> +#
>> +menu "Texas Instruments shared transport line discipline"
>> +    config TI_ST
>> +    tristate "shared transport core driver"
>> +    select FW_LOADER
>> +    help
>> +        This enables the shared transport core driver for TI
>> +         BT / FM and GPS combo chips.This enables protocol drivers
>> +         to register themselves with core and send data, the responses
>> +         are returned to relevant protocol drivers based on their
>> +         packet types.
> 
> Please indent kconfig help text with one tab + 2 spaces.
> 
>> +
>> +    config ST_BT
>> +    tristate "BlueZ bluetooth driver for ST"
> 
> I'd be careful.  There are some places in the kernel tree where ST
> means STMicroelectronics.
> 
>> +    select BT
> 
> That select looks unsafe.  You don't know that CONFIG_NET  is even enabled here,
> do you?  Most drivers use "depends on BT" instead of "select BT" from my grepping.
> 
> 
> 
>> +    select TI_ST
>> +    help
>> +       This enables the Bluetooth driver for TI BT/FM/GPS combo devices
> 
> End sentence with period.
> 
>> +       This makes use of shared transport line discipline core driver to
>> +       communicate with the BT core of the combo chip.
>> +endmenu
>> diff --git a/drivers/misc/ti-st/Makefile b/drivers/misc/ti-st/Makefile
>> new file mode 100644
>> index 0000000..cff3770
>> --- /dev/null
>> +++ b/drivers/misc/ti-st/Makefile
>> @@ -0,0 +1,7 @@
>> +#
>> +# Makefile for TI's shared transport line discipline
>> +# and it's protocol drivers (BT, FM, GPS)
> 
>          its
> 
>> +#
>> +obj-$(CONFIG_TI_ST) += st_drv.o
>> +st_drv-objs                  := st_core.o st_kim.o st_ll.o
>> +obj-$(CONFIG_ST_BT) += bt_drv.o
> 
> 
> --
> ~Randy
> 
> 
> 
> From 91b326a876066f0724f08957ee446f6b6bbed40e Mon Sep 17 00:00:00 2001
> From: Pavan Savoy <pavan_savoy@ti.com>
> Date: Mon, 22 Mar 2010 16:40:19 -0400
> Subject: [PATCH 2/7] drivers:misc: Kconfig, Makefile for TI's ST ldisc
> This change adds the Kconfig and Make file for TI's
> ST line discipline driver and the BlueZ driver for BT
> core of the TI BT/FM/GPS combo chip.
> Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
> ---
>  drivers/misc/Kconfig        |    1 +
>  drivers/misc/Makefile       |    1 +
>  drivers/misc/ti-st/Kconfig  |   24 ++++++++++++++++++++++++
>  drivers/misc/ti-st/Makefile |    7 +++++++
>  4 files changed, 33 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/misc/ti-st/Kconfig
>  create mode 100644 drivers/misc/ti-st/Makefile
> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index 625e3a6..c059bca 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -344,5 +344,6 @@ source "drivers/misc/c2port/Kconfig"
>  source "drivers/misc/eeprom/Kconfig"
>  source "drivers/misc/cb710/Kconfig"
>  source "drivers/misc/iwmc3200top/Kconfig"
> +source "drivers/misc/ti-st/Kconfig"
>  
>  endif # MISC_DEVICES
> diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
> index c221917..021f282 100644
> --- a/drivers/misc/Makefile
> +++ b/drivers/misc/Makefile
> @@ -30,3 +30,4 @@ obj-$(CONFIG_IWMC3200TOP)      += iwmc3200top/
>  obj-$(CONFIG_HWLAT_DETECTOR) += hwlat_detector.o
>  obj-y    += eeprom/
>  obj-y    += cb710/
> +obj-y    += ti-st/
> diff --git a/drivers/misc/ti-st/Kconfig b/drivers/misc/ti-st/Kconfig
> new file mode 100644
> index 0000000..fe5b0e8
> --- /dev/null
> +++ b/drivers/misc/ti-st/Kconfig
> @@ -0,0 +1,24 @@
> +#
> +# TI's shared transport line discipline and the protocol
> +# drivers (BT, FM and GPS)
> +#
> +menu "Texas Instruments shared transport line discipline"
> +    config TI_ST
> +    tristate "shared transport core driver"
> +    select FW_LOADER
> +    help
> +   This enables the shared transport core driver for TI
> +   BT / FM and GPS combo chips.This enables protocol drivers
> +   to register themselves with core and send data, the responses
> +   are returned to relevant protocol drivers based on their
> +   packet types.
> +
> +    config ST_BT
> +    tristate "BlueZ bluetooth driver for ST"
> +    depends on BT

OK.

> +    select TI_ST
> +    help
> +   This enables the Bluetooth driver for TI BT/FM/GPS combo devices
> +   This makes use of shared transport line discipline core driver to
> +   communicate with the BT core of the combo chip.

There are no tabs above.  They appear to have been eaten (assuming that
they were there at some point).


> +endmenu
> diff --git a/drivers/misc/ti-st/Makefile b/drivers/misc/ti-st/Makefile
> new file mode 100644
> index 0000000..cff3770
> --- /dev/null
> +++ b/drivers/misc/ti-st/Makefile
> @@ -0,0 +1,7 @@
> +#
> +# Makefile for TI's shared transport line discipline
> +# and it's protocol drivers (BT, FM, GPS)

         ^^^^
should be "its"

> +#
> +obj-$(CONFIG_TI_ST) += st_drv.o
> +st_drv-objs   := st_core.o st_kim.o st_ll.o
> +obj-$(CONFIG_ST_BT) += bt_drv.o


> PS:
> If you still see problems with identation - blame my email editor (outlook express)

I guess that you'll need to do something about that.


-- 
~Randy
