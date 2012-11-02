Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761869Ab2KBMrq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 08:47:46 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:52182 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758308Ab2KBMrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 08:47:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: wency@cn.fujitsu.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, liuj97@gmail.com, len.brown@intel.com,
        akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, laijs@cn.fujitsu.com
Subject: Re: [PATCH v3 0/3] acpi,memory-hotplug : implement framework for hot removing memory
Date: Fri, 02 Nov 2012 13:51:49 +0100
Message-ID: <1528960.KUfu6MoGpQ@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc3; KDE/4.8.5; x86_64; ; )
In-Reply-To: <1351247463-5653-1-git-send-email-wency@cn.fujitsu.com>
References: <1351247463-5653-1-git-send-email-wency@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 26, 2012 06:31:00 PM wency@cn.fujitsu.com wrote:
> From: Wen Congyang <wency@cn.fujitsu.com>
> 
> The patch-set implements a framework for hot removing memory.
> 
> The memory device can be removed by 2 ways:
> 1. send eject request by SCI
> 2. echo 1 >/sys/bus/pci/devices/PNP0C80:XX/eject
> 
> In the 1st case, acpi_memory_disable_device() will be called.
> In the 2nd case, acpi_memory_device_remove() will be called.
> acpi_memory_device_remove() will also be called when we unbind the
> memory device from the driver acpi_memhotplug or a driver initialization
> fails.
> 
> acpi_memory_disable_device() has already implemented a code which
> offlines memory and releases acpi_memory_info struct . But
> acpi_memory_device_remove() has not implemented it yet.
> 
> So the patch prepares the framework for hot removing memory and
> adds the framework into acpi_memory_device_remove().
> 
> The last version of this patchset is here:
> https://lkml.org/lkml/2012/10/19/156
> 
> Changelogs from v2 to v3:
>   Patch2: rename lock to list_lock
> 
> Changelogs from v1 to v2:
>   Patch1: use acpi_bus_trim() instead of acpi_bus_remove()
>   Patch2: new patch, introduce a lock to protect the list
>   Patch3: remove memory too when type is ACPI_BUS_REMOVAL_NORMAL
>   Note: I don't send [Patch2-4 v1] in this series because they
>   are no logical changes in these 3 patches.
> 
> Wen Congyang (2):
>   acpi,memory-hotplug: call acpi_bus_trim() to remove memory device
>   acpi,memory-hotplug: introduce a mutex lock to protect the list in
>     acpi_memory_device
> 
> Yasuaki Ishimatsu (1):
>   acpi,memory-hotplug : add memory offline code to
>     acpi_memory_device_remove()
> 
>  drivers/acpi/acpi_memhotplug.c | 51 +++++++++++++++++++++++++++++++++---------
>  1 file changed, 41 insertions(+), 10 deletions(-)

All patches in the series applied to the linux-next branch of the linux-pm.git
tree as v3.8 material.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
