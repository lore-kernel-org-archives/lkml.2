Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab2LGHPn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 02:15:43 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37096 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753Ab2LGHPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 02:15:41 -0500
MIME-Version: 1.0
In-Reply-To: <1352003971-22278-1-git-send-email-yinghai@kernel.org>
References: <20121030040237.GA10472@google.com>
	<1352003971-22278-1-git-send-email-yinghai@kernel.org>
Date: Thu, 6 Dec 2012 23:15:39 -0800
X-Google-Sender-Auth: W1On6Brq_xZVcKZh6wEuRtIQJ_g
Message-ID: <CAE9FiQUn=bcgOLFzBwsBT1-O1poRNy9qYTb0w9EAya3_inKqAw@mail.gmail.com>
Subject: Re: [PATCH 0/8] PCI, ACPI, x86: Reserve fw allocated resource for
 hot-add root bus
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <lenb@kernel.org>, Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 3, 2012 at 9:39 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> For root bus hot add, fw could assign some resource for the devices for
> that root bus before notifying os via acpi, we should check and use those
> resources at first just like we do for booting path.
>
> At first, we need to refactor x86 pci pcibios_allocate related functions
> for booting path to take bus as parameter.
>
> After that, we could use the survey function for hot add root bus.
>
> based on pci/yinghai-for-pci-root-bus-hotplug
>
> could get from
>         git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci-survey-resources
>
> Yinghai Lu (8):
>   PCI, x86: Separate out pcibios_allocate_bridge_resources()
>   PCI, x86: Separate out pcibios_allocate_dev_resources()
>   PCI, x86: Let pcibios_allocate_bus_resources() take bus instead
>   PCI, x86: Separate out rom resource claim
>   PCI, x86: Add pcibios_fw_addr_done
>   PCI, x86: Remove __init for hw/fw allocated functions
>   PCI, x86: Claim FW allocated resources in hot add path.
>   PCI, ACPI: reserve fw allocated resource for hot added root bus
>
>  arch/x86/pci/i386.c     |  185 +++++++++++++++++++++++++++++++----------------
>  drivers/acpi/pci_root.c |    4 +-
>  drivers/pci/bus.c       |    2 +
>  include/linux/pci.h     |    1 +
>  4 files changed, 127 insertions(+), 65 deletions(-)
>

Bjorn,

Can you queue those 8 patches for v3.9 in pci tree?

So I  could resend out other pci root hotplug patches.

Thanks

Yinghai
