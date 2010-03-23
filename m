Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926Ab0CWQF5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 12:05:57 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:27785 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499Ab0CWQF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 12:05:56 -0400
Date: Tue, 23 Mar 2010 09:04:09 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Pavan Savoy <pavan_savoy@ti.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 2/6] drivers:misc: Kconfig, Makefile for TI's ST ldisc
Message-Id: <20100323090409.d930d622.randy.dunlap@oracle.com>
In-Reply-To: <4BA8E484.3000509@ti.com>
References: <4BA8E484.3000509@ti.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4BA8E6C9.0027:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Mar 2010 10:55:48 -0500 Pavan Savoy wrote:

> 
> [pavan]
> Try git apply. I gave it a try with patch/diff, doesn't seem to work.

Well, so far, it has to work with patch/diff also...
That may change one of these days.  :(


> [pavan]
> Hopefully this should be fine,
> 

Yes, looks fine now.  Thanks for persisting.

> 
>  From c8dbc8047e5139e7912dc8c519fa62866c98b64b Mon Sep 17 00:00:00 2001
> From: Pavan Savoy <pavan_savoy@ti.com>
> Date: Mon, 22 Mar 2010 16:40:19 -0400
> Subject: [PATCH 2/7] drivers:misc: Kconfig, Makefile for TI's ST ldisc
> 
> This change adds the Kconfig and Make file for TI's
> ST line discipline driver and the BlueZ driver for BT
> core of the TI BT/FM/GPS combo chip.
> 
> Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
> ---
>   drivers/misc/Kconfig        |    1 +
>   drivers/misc/Makefile       |    1 +
>   drivers/misc/ti-st/Kconfig  |   24 ++++++++++++++++++++++++
>   drivers/misc/ti-st/Makefile |    7 +++++++
>   4 files changed, 33 insertions(+), 0 deletions(-)
>   create mode 100644 drivers/misc/ti-st/Kconfig
>   create mode 100644 drivers/misc/ti-st/Makefile
> 
> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index 625e3a6..c059bca 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -344,5 +344,6 @@ source "drivers/misc/c2port/Kconfig"
>   source "drivers/misc/eeprom/Kconfig"
>   source "drivers/misc/cb710/Kconfig"
>   source "drivers/misc/iwmc3200top/Kconfig"
> +source "drivers/misc/ti-st/Kconfig"
> 
>   endif # MISC_DEVICES
> diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
> index c221917..021f282 100644
> --- a/drivers/misc/Makefile
> +++ b/drivers/misc/Makefile
> @@ -30,3 +30,4 @@ obj-$(CONFIG_IWMC3200TOP)      += iwmc3200top/
>   obj-$(CONFIG_HWLAT_DETECTOR)	+= hwlat_detector.o
>   obj-y				+= eeprom/
>   obj-y				+= cb710/
> +obj-y				+= ti-st/
> diff --git a/drivers/misc/ti-st/Kconfig b/drivers/misc/ti-st/Kconfig
> new file mode 100644
> index 0000000..120e8db
> --- /dev/null
> +++ b/drivers/misc/ti-st/Kconfig
> @@ -0,0 +1,24 @@
> +#
> +# TI's shared transport line discipline and the protocol
> +# drivers (BT, FM and GPS)
> +#
> +menu "Texas Instruments shared transport line discipline"
> +config TI_ST
> +	tristate "shared transport core driver"
> +	select FW_LOADER
> +	help
> +	  This enables the shared transport core driver for TI
> +	  BT / FM and GPS combo chips. This enables protocol drivers
> +	  to register themselves with core and send data, the responses
> +	  are returned to relevant protocol drivers based on their
> +	  packet types.
> +
> +config ST_BT
> +	tristate "BlueZ bluetooth driver for ST"
> +	depends on BT
> +	select TI_ST
> +	help
> +	  This enables the Bluetooth driver for TI BT/FM/GPS combo devices.
> +	  This makes use of shared transport line discipline core driver to
> +	  communicate with the BT core of the combo chip.
> +endmenu
> diff --git a/drivers/misc/ti-st/Makefile b/drivers/misc/ti-st/Makefile
> new file mode 100644
> index 0000000..0167d1d
> --- /dev/null
> +++ b/drivers/misc/ti-st/Makefile
> @@ -0,0 +1,7 @@
> +#
> +# Makefile for TI's shared transport line discipline
> +# and its protocol drivers (BT, FM, GPS)
> +#
> +obj-$(CONFIG_TI_ST) 		+= st_drv.o
> +st_drv-objs			:= st_core.o st_kim.o st_ll.o
> +obj-$(CONFIG_ST_BT) 		+= bt_drv.o
> -- 


---
~Randy
