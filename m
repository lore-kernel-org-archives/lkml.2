Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752Ab2GYJqY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 05:46:24 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:25608 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641Ab2GYJqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 05:46:22 -0400
Message-ID: <500FC011.5050807@huawei.com>
Date: Wed, 25 Jul 2012 17:44:49 +0800
From: Jiang Liu <jiang.liu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: "Kaneshige, Kenji" <kaneshige.kenji@jp.fujitsu.com>
CC: Jiang Liu <liuj97@gmail.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Don Dutile <ddutile@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        "Izumi, Taku" <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Yijing Wang <wangyijing@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [RFC PATCH v2 07/32] PCI/portdrv: use PCIe capabilities access
 functions to simplify implementation
References: <1343147504-25891-1-git-send-email-jiang.liu@huawei.com> <1343147504-25891-8-git-send-email-jiang.liu@huawei.com> <4A338DB2991D2A44B9A44B8718AECF650A4586BC@G01JPEXMBYT03>
In-Reply-To: <4A338DB2991D2A44B9A44B8718AECF650A4586BC@G01JPEXMBYT03>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.108.108.229]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> diff --git a/drivers/pci/pcie/portdrv_core.c
>> b/drivers/pci/pcie/portdrv_core.c
>> index bf320a9..37bff83 100644
>> --- a/drivers/pci/pcie/portdrv_core.c
>> +++ b/drivers/pci/pcie/portdrv_core.c
>> @@ -76,7 +76,6 @@ static int pcie_port_enable_msix(struct pci_dev *dev,
>> int *vectors, int mask)
>>  	struct msix_entry *msix_entries;
>>  	int idx[PCIE_PORT_DEVICE_MAXSERVICES];
>>  	int nr_entries, status, pos, i, nvec;
>> -	u16 reg16;
>>  	u32 reg32;
>>
>>  	nr_entries = pci_msix_table_size(dev);
>> @@ -120,9 +119,7 @@ static int pcie_port_enable_msix(struct pci_dev *dev,
>> int *vectors, int mask)
>>  		 * the value in this field indicates which MSI-X Table entry
>> is
>>  		 * used to generate the interrupt message."
>>  		 */
>> -		pos = pci_pcie_cap(dev);
>> -		pci_read_config_word(dev, pos + PCI_EXP_FLAGS, &reg16);
>> -		entry = (reg16 & PCI_EXP_FLAGS_IRQ) >> 9;
>> +		entry = (dev->pcie_flags_reg & PCI_EXP_FLAGS_IRQ) >> 9;
>>  		if (entry >= nr_entries)
>>  			goto Error;
> 
> I think we need to use pci_read_config_word() for MSI setup.
> 
> "Interrupt Message Number" in the PCIe capability register can vary depending
> on whether MSI or MSI-x is enabled. Please see PCIe spec for details.
> 
> Could you double-check that?
> 
> Regards,
> Kenji Kaneshige
Good catch, will revert this change.
Thanks!
Gerry

