Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758565Ab2JSKUW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 06:20:22 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58139 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758336Ab2JSKUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 06:20:20 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <50812949.6040005@jp.fujitsu.com>
Date: Fri, 19 Oct 2012 19:19:53 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: <wency@cn.fujitsu.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <linux-acpi@vger.kernel.org>, <liuj97@gmail.com>,
        <len.brown@intel.com>, <akpm@linux-foundation.org>,
        <kosaki.motohiro@jp.fujitsu.com>, <muneda.takahiro@jp.fujitsu.com>,
        <rjw@sisk.pl>
Subject: Re: [PATCH v2 0/3] acpi,memory-hotplug : implement framework for
 hot removing memory
References: <1350641040-19434-1-git-send-email-wency@cn.fujitsu.com>
In-Reply-To: <1350641040-19434-1-git-send-email-wency@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CCing Rafael, because he become ACPI Maintainer.

Hi Wen,

If you update the patch-set, please CCing Rafael from the next time.

Thanks,
Yasuaki Ishimatsu

2012/10/19 19:03, wency@cn.fujitsu.com wrote:
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
> https://lkml.org/lkml/2012/10/3/126
> 
> Changelos from v1 to v2:
>    Patch1: use acpi_bus_trim() instead of acpi_bus_remove()
>    Patch2: new patch, introduce a lock to protect the list
>    Patch3: remove memory too when type is ACPI_BUS_REMOVAL_NORMAL
>    Note: I don't send [Patch2-4 v1] in this series because they
>    are no logical changes in these 3 patches.
> 
> Wen Congyang (2):
>    acpi,memory-hotplug: call acpi_bus_trim() to remove memory device
>    acpi,memory-hotplug: introduce a mutex lock to protect the list in
>      acpi_memory_device
> 
> Yasuaki Ishimatsu (1):
>    acpi,memory-hotplug : add memory offline code to
>      acpi_memory_device_remove()
> 
>   drivers/acpi/acpi_memhotplug.c |   51 ++++++++++++++++++++++++++++++++--------
>   1 files changed, 41 insertions(+), 10 deletions(-)
> 


