Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328Ab2DIPLI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 11:11:08 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:53415 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756576Ab2DIPLG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 11:11:06 -0400
MIME-Version: 1.0
In-Reply-To: <4F82F42C.5040301@gmail.com>
References: <20120406115948.3536e6c8.izumi.taku@jp.fujitsu.com>
	<1333905129-8776-1-git-send-email-jiang.liu@huawei.com>
	<1333905129-8776-3-git-send-email-jiang.liu@huawei.com>
	<CAE9FiQXNOJA4oCDw-CF32UjaA=6tri73nXP3u6+hMEjpugjF9w@mail.gmail.com>
	<4F82F42C.5040301@gmail.com>
Date: Mon, 9 Apr 2012 08:11:05 -0700
X-Google-Sender-Auth: jUqBL7YRHKf8djtsOfMyIhQbIkU
Message-ID: <CAE9FiQXsbSikFYuTECH7QbHLxFOA1uZ-=oC_v6-7fzdC4V0PSA@mail.gmail.com>
Subject: Re: [PATCH 2/2] PCI, ACPI, x86: update MMCFG information when
 hot-plugging PCI host bridges
From: Yinghai Lu <yinghai@kernel.org>
To: Jiang Liu <liuj97@gmail.com>
Cc: Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Keping Chen <chenkeping@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 9, 2012 at 7:37 AM, Jiang Liu <liuj97@gmail.com> wrote:
> Hi Yinghai,
>
>>> +int arch_acpi_pci_root_remove(struct acpi_pci_root *root)
>>> +{
>>> +       acpi_status status;
>>> +       unsigned long long base_addr;
>>> +
>>> +       /* Remove MMCFG information for host bridges with _CBA method */
>>> +       status = acpi_evaluate_integer(root->device->handle, METHOD_NAME__CBA,
>>> +                                      NULL, &base_addr);
>>
>> add one flag in acpi_pci_root about we added mmconf for it before?
>> like mmconf_added?
>>
>
> I feel adding a flag here doesn't help here. For any hot-pluggable PCI host bridge
> with _CBA method available, arch_acpi_pci_root_remove() should delete the MMCFG
> information, no matter it's added by __pci_mmcfg_init() or arch_acpi_pci_root_add().
> So check existence of _CBA seems simpler here.

_remove should not care about _CBA, it should only care about if it
gets added on _add path.

Also like Kenji said, We should let it go through even no MMCONF is
added at that time.
like somehow _CBA does not exis for some root bus or evaluating failing etc.

Yinghai
