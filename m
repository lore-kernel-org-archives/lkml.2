Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab1BVLVj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 06:21:39 -0500
Received: from www.tglx.de ([62.245.132.106]:35014 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860Ab1BVLVh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 06:21:37 -0500
Date: Tue, 22 Feb 2011 12:21:23 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, sodaville@linutronix.de,
        devicetree-discuss@lists.ozlabs.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [sodaville] [PATCH TIP 08/14] x86/dtb: add support for PCI devices backed by dtb nodes
Message-ID: <20110222112123.GB24641@www.tglx.de>
References: <1295843342-1122-1-git-send-email-bigeasy@linutronix.de> <1295843342-1122-9-git-send-email-bigeasy@linutronix.de> <AANLkTimWxmEcr=7AibGUht3bBi7ms2MRqj4Qj-jwEGBB@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <AANLkTimWxmEcr=7AibGUht3bBi7ms2MRqj4Qj-jwEGBB@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Grant Likely | 2011-02-16 14:59:15 [-0700]:

>> diff --git a/arch/x86/include/asm/prom.h b/arch/x86/include/asm/prom.h
>> index bd67ab2..3ed0bd6 100644
>> --- a/arch/x86/include/asm/prom.h
>> +++ b/arch/x86/include/asm/prom.h
>> @@ -28,8 +29,24 @@ extern void add_dtb(u64 data);
>>  void x86_dtb_find_config(void);
>>  void x86_dtb_get_config(unsigned int unused);
>>  void add_interrupt_host(struct irq_domain *ih);
>> +void __cpuinit x86_of_pci_init(void);
>> +
>> +static inline struct device_node *pci_device_to_OF_node(struct pci_dev *pdev)
>> +{
>> +       return pdev->dev.of_node;
>> +}
>> +
>> +static inline struct device_node *pci_bus_to_OF_node(struct pci_bus *bus)
>> +{
>> +       if (bus->self)
>> +               return pci_device_to_OF_node(bus->self);
>> +       else
>> +               return NULL;
>> +}
>
>Nit: could simply be:
>
>static inline struct device_node *pci_device_to_OF_node(struct pci_dev *pdev)
>{
>       return pdev ? pdev->dev.of_node : NULL;
>}
>
>static inline struct device_node *pci_bus_to_OF_node(struct pci_bus *bus)
>{
>       return pci_device_to_OF_node(bus->self);
>}
>
done.

Sebastian
