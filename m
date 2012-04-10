Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759171Ab2DJPr3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 11:47:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39864 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755905Ab2DJPr2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 11:47:28 -0400
MIME-Version: 1.0
In-Reply-To: <4F840C3C.2060302@jp.fujitsu.com>
References: <1333905129-8776-1-git-send-email-jiang.liu@huawei.com>
	<1333905129-8776-3-git-send-email-jiang.liu@huawei.com>
	<4F82CB64.8030808@jp.fujitsu.com>
	<4F830804.6010007@gmail.com>
	<4F840C3C.2060302@jp.fujitsu.com>
Date: Tue, 10 Apr 2012 08:47:27 -0700
X-Google-Sender-Auth: JMyfEI1-LMyqUQJ8wFmNRr0iqiY
Message-ID: <CAE9FiQWZwkyp8F7HDTpGVZ=Q=09_68NR3tT_vCzwFH3ZhXDzCA@mail.gmail.com>
Subject: Re: [PATCH 2/2] PCI, ACPI, x86: update MMCFG information when
 hot-plugging PCI host bridges
From: Yinghai Lu <yinghai@kernel.org>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Jiang Liu <liuj97@gmail.com>, Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Keping Chen <chenkeping@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 3:32 AM, Kenji Kaneshige
<kaneshige.kenji@jp.fujitsu.com> wrote:
> Additionally, I think there is a remaining issue even if we change
> this check like below.
>
>
>        if (!!(pci_probe & PCI_PROBE_MASK & ~PCI_PROBE_MMCONF))
>                return 0;
>
> I think this check has an assumption that system has at least one
> MCFG table entry and it has been initialized before
> acpi_pci_root_add() is called. I think this doesn't work on the
> system that doesn't have MCFG and all the pci root bridge have
> _CBA (that is, all host bridges are hot-pluggable and BIOS is
> implemented in the way PCI FW spec defines). As a result, MMCONFIG
> would never be enabled on such systems. Could you double check this?

You are right.

We can just remove that checking.

But wonder if current x86_64 system support that.
All peer root buses can be physically removed ?

Thanks

Yinghai
