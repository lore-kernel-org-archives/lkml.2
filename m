Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833Ab1EGQOC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 12:14:02 -0400
Received: from server19320154104.serverpool.info ([193.201.54.104]:40805 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755712Ab1EGQN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 12:13:58 -0400
Message-ID: <4DC56FB9.5000208@hauke-m.de>
Date: Sat, 07 May 2011 18:13:45 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        b43-dev@lists.infradead.org, Greg KH <greg@kroah.com>,
        =?UTF-8?B?TWljaGFl?= =?UTF-8?B?bCBCw7xzY2g=?= <mb@bu3sch.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        George Kashperko <george@znau.edu.ua>,
        Arend van Spriel <arend@broadcom.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <rmk@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Andy Botting <andy@andybotting.com>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][WAS:bcmai,axi] bcma: add Broadcom specific AMBA bus driver
References: <1304632783-8781-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1304632783-8781-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2011 11:59 PM, Rafał Miłecki wrote:
> Cc: Greg KH <greg@kroah.com>
> Cc: Michael Büsch <mb@bu3sch.de>
> Cc: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: George Kashperko <george@znau.edu.ua>
> Cc: Arend van Spriel <arend@broadcom.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: Russell King <rmk@arm.linux.org.uk>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Andy Botting <andy@andybotting.com>
> Cc: linuxdriverproject <devel@linuxdriverproject.org>
> Cc: linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
> V2: Rename to axi
>     Use DEFINE_PCI_DEVICE_TABLE in bridge
>     Make use of pr_fmt and pr_*
>     Store core class
>     Rename bridge to not b43 specific
>     Replace magic 0x1000 with BCMAI_CORE_SIZE
>     Remove some old "ssb" names and defines
>     Move BCMAI_ADDR_BASE def
>     Add drvdata field
> V3: Fix reloading (kfree issue)
>     Add 14e4:0x4331
>     Fix non-initialized struct issue
>     Drop useless inline functions wrappers for pci core drv
>     Proper pr_* usage
> V3.1: Include forgotten changes (pr_* and include related)
>     Explain why we dare to implement empty release function
> V4: Add ABI documentation
>     Move struct device to wrapper and alloc it dynamically
>     checkpatch.pl pointed fixes
> V5: Rename to bcma, AXI was really bad name
>     Use EXPORT_SYMBOL_GPL
>     Set pci driver fields in one place
>     Drop unlikely
>     Use BCMA_CORE_SIZE for calc in awrite32
>     Add README
>     Fix compilation (delay.h)
> ---
>  Documentation/ABI/testing/sysfs-bus-bcma    |   31 ++
>  drivers/Kconfig                             |    2 +
>  drivers/Makefile                            |    1 +
>  drivers/bcma/Kconfig                        |   33 +++
>  drivers/bcma/Makefile                       |    7 +
>  drivers/bcma/README                         |   18 ++
>  drivers/bcma/TODO                           |    3 +
>  drivers/bcma/bcma_private.h                 |   31 ++
>  drivers/bcma/core.c                         |   51 ++++
>  drivers/bcma/driver_chipcommon.c            |   87 ++++++
>  drivers/bcma/driver_chipcommon_pmu.c        |  134 +++++++++
>  drivers/bcma/driver_pci.c                   |  163 +++++++++++
>  drivers/bcma/host_pci.c                     |  196 +++++++++++++
>  drivers/bcma/main.c                         |  271 ++++++++++++++++++
>  drivers/bcma/scan.c                         |  392 +++++++++++++++++++++++++++
>  drivers/bcma/scan.h                         |   56 ++++
>  include/linux/bcma/bcma.h                   |  232 ++++++++++++++++
>  include/linux/bcma/bcma_driver_chipcommon.h |  297 ++++++++++++++++++++
>  include/linux/bcma/bcma_driver_pci.h        |   89 ++++++
>  include/linux/bcma/bcma_regs.h              |   34 +++
>  include/linux/mod_devicetable.h             |   17 ++
>  scripts/mod/file2alias.c                    |   22 ++
>  22 files changed, 2167 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-bus-bcma
>  create mode 100644 drivers/bcma/Kconfig
>  create mode 100644 drivers/bcma/Makefile
>  create mode 100644 drivers/bcma/README
>  create mode 100644 drivers/bcma/TODO
>  create mode 100644 drivers/bcma/bcma_private.h
>  create mode 100644 drivers/bcma/core.c
>  create mode 100644 drivers/bcma/driver_chipcommon.c
>  create mode 100644 drivers/bcma/driver_chipcommon_pmu.c
>  create mode 100644 drivers/bcma/driver_pci.c
>  create mode 100644 drivers/bcma/host_pci.c
>  create mode 100644 drivers/bcma/main.c
>  create mode 100644 drivers/bcma/scan.c
>  create mode 100644 drivers/bcma/scan.h
>  create mode 100644 include/linux/bcma/bcma.h
>  create mode 100644 include/linux/bcma/bcma_driver_chipcommon.h
>  create mode 100644 include/linux/bcma/bcma_driver_pci.h
>  create mode 100644 include/linux/bcma/bcma_regs.h
> 
Hi,

An entry in the MAINTAINERS file would be nice to find the right
addresses to send patches to.

Hauke
