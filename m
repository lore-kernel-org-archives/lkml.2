Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757854Ab1DHUAm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 16:00:42 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:35311 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757715Ab1DHUAk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 16:00:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=aPXoEAnemRdj0LoOH+DqYPpFp2QoiJ4MWX6Oc2CZWGx6U6Ggm89xfXE6d6dM8qiSr+
         Vkzra3ix8mhTL1vbkYcVY2TzAtsNi/uB1Y2K9rSnP5t+cApVJ7p6QcHv406BE4z1CFzW
         B+WDjdADlGra4/e8AKLwxy16VipLoJKcxpIsE=
MIME-Version: 1.0
In-Reply-To: <1302291900-1902-1-git-send-email-zajec5@gmail.com>
References: <1302291900-1902-1-git-send-email-zajec5@gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Fri, 8 Apr 2011 22:00:19 +0200
Message-ID: <BANLkTi=VvH-rahnK8VhmuPWhkshuEdqR6g@mail.gmail.com>
Subject: Re: [RFC][WAS:bcmai][PATCH V2] axi: add AXI bus driver
To: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        b43-dev@lists.infradead.org,
        =?ISO-8859-1?Q?Michael_B=FCsch?= <mb@bu3sch.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        George Kashperko <george@znau.edu.ua>,
        Arend van Spriel <arend@broadcom.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <rmk@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 8, 2011 at 9:45 PM, Rafał Miłecki <zajec5@gmail.com> wrote:
> Cc: Michael Büsch <mb@bu3sch.de>
> Cc: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: George Kashperko <george@znau.edu.ua>
> Cc: Arend van Spriel <arend@broadcom.com>
> Cc: linux-arm-kernel@lists.infradead.org <linux-arm-kernel@lists.infradead.org>
> Cc: Russell King <rmk@arm.linux.org.uk>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: linuxdriverproject <devel@linuxdriverproject.org>
> Cc: linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
> This is second try for introducing new bus driver.
> V2: Rename to axi
>    Use DEFINE_PCI_DEVICE_TABLE in bridge
>    Make use of pr_fmt and pr_*
>    Store core class
>    Rename bridge to not b43 specific
>    Replace magic 0x1000 with BCMAI_CORE_SIZE
>    Remove some old "ssb" names and defines
>    Move BCMAI_ADDR_BASE def
>    Add drvdata field
> TODO:
> - Interrupts
> - Reloading driver
> ---
>  drivers/Kconfig                           |    2 +
>  drivers/Makefile                          |    1 +
>  drivers/axi/Kconfig                       |   30 +++
>  drivers/axi/Makefile                      |    5 +
>  drivers/axi/axi_pci_bridge.c              |   33 +++
>  drivers/axi/axi_private.h                 |   45 ++++
>  drivers/axi/core.c                        |   52 ++++
>  drivers/axi/driver_chipcommon.c           |   87 +++++++
>  drivers/axi/driver_chipcommon_pmu.c       |  134 ++++++++++
>  drivers/axi/driver_pci.c                  |  191 ++++++++++++++
>  drivers/axi/host_pci.c                    |  177 +++++++++++++
>  drivers/axi/main.c                        |  256 +++++++++++++++++++
>  drivers/axi/scan.c                        |  393 +++++++++++++++++++++++++++++
>  drivers/axi/scan.h                        |   56 ++++
>  include/linux/axi/axi.h                   |  221 ++++++++++++++++
>  include/linux/axi/axi_driver_chipcommon.h |  308 ++++++++++++++++++++++
>  include/linux/axi/axi_driver_pci.h        |   85 +++++++
>  include/linux/axi/axi_regs.h              |   34 +++
>  include/linux/mod_devicetable.h           |   17 ++
>  scripts/mod/file2alias.c                  |   21 ++
>  20 files changed, 2148 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/axi/Kconfig
>  create mode 100644 drivers/axi/Makefile
>  create mode 100644 drivers/axi/axi_pci_bridge.c
>  create mode 100644 drivers/axi/axi_private.h
>  create mode 100644 drivers/axi/core.c
>  create mode 100644 drivers/axi/driver_chipcommon.c
>  create mode 100644 drivers/axi/driver_chipcommon_pmu.c
>  create mode 100644 drivers/axi/driver_pci.c
>  create mode 100644 drivers/axi/host_pci.c
>  create mode 100644 drivers/axi/main.c
>  create mode 100644 drivers/axi/scan.c
>  create mode 100644 drivers/axi/scan.h
>  create mode 100644 include/linux/axi/axi.h
>  create mode 100644 include/linux/axi/axi_driver_chipcommon.h
>  create mode 100644 include/linux/axi/axi_driver_pci.h
>  create mode 100644 include/linux/axi/axi_regs.h
>
> diff --git a/drivers/Kconfig b/drivers/Kconfig
> index 177c7d1..1244e8c 100644
> --- a/drivers/Kconfig
> +++ b/drivers/Kconfig
> @@ -68,6 +68,8 @@ source "drivers/watchdog/Kconfig"
>
>  source "drivers/ssb/Kconfig"
>
> +source "drivers/axi/Kconfig"
> +
>  source "drivers/mfd/Kconfig"
>
>  source "drivers/regulator/Kconfig"
> diff --git a/drivers/Makefile b/drivers/Makefile
> index 3f135b6..6e1979b 100644
> --- a/drivers/Makefile
> +++ b/drivers/Makefile
> @@ -110,6 +110,7 @@ obj-$(CONFIG_HID)           += hid/
>  obj-$(CONFIG_PPC_PS3)          += ps3/
>  obj-$(CONFIG_OF)               += of/
>  obj-$(CONFIG_SSB)              += ssb/
> +obj-$(CONFIG_AXI)              += axi/
>  obj-$(CONFIG_VHOST_NET)                += vhost/
>  obj-$(CONFIG_VLYNQ)            += vlynq/
>  obj-$(CONFIG_STAGING)          += staging/
> diff --git a/drivers/axi/Kconfig b/drivers/axi/Kconfig
> new file mode 100644
> index 0000000..f4f58f5
> --- /dev/null
> +++ b/drivers/axi/Kconfig
> @@ -0,0 +1,30 @@
> +config AXI_POSSIBLE
> +       bool
> +       depends on HAS_IOMEM && HAS_DMA
> +       default y
> +
> +menu "AMBA AXI"
> +       depends on AXI_POSSIBLE
> +
> +config AXI
> +       tristate "AXI support"
> +       depends on AXI_POSSIBLE
> +
> +config AXI_HOST_PCI_POSSIBLE
> +       bool
> +       depends on AXI && PCI = y
> +       default y
> +
> +config AXI_HOST_PCI
> +       bool "Support for AI on PCI-host bus"

Shouldn't this say AXI?

> +       depends on AXI_HOST_PCI_POSSIBLE
> +
> +config AXI_DEBUG
> +       bool "AXI debugging"
> +       depends on AXI
> +       help
> +         This turns on additional debugging messages.
> +
> +         If unsure, say N
> +
> +endmenu
