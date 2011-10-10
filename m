Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935Ab1JJMCe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 08:02:34 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:34461 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799Ab1JJMCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 08:02:33 -0400
Message-ID: <4E92DEC1.5050806@oracle.com>
Date: Mon, 10 Oct 2011 17:32:09 +0530
From: Ajaykumar Hotchandani <ajaykumar.hotchandani@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Yinghai Lu <yhlu.kernel@gmail.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PCI: Set device power state to PCI_D0 for device without
 native PM support
References: <4E8C40A8.6080205@oracle.com> <alpine.DEB.2.00.1110061137120.3519@kaball-desktop> <CAE9FiQVyT=n18JnuBmda86D77Ai4HAC=w68Oo-Na3mCdAxsCMw@mail.gmail.com> <alpine.DEB.2.00.1110061711290.3519@kaball-desktop>
In-Reply-To: <alpine.DEB.2.00.1110061711290.3519@kaball-desktop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet24.oracle.com [156.151.31.67]
X-CT-RefId: str=0001.0A090209.4E92DED3.01AD,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 10/06/2011 09:47 PM, Stefano Stabellini wrote:
> On Thu, 6 Oct 2011, Yinghai Lu wrote:
>> On Thu, Oct 6, 2011 at 3:39 AM, Stefano Stabellini
>> <stefano.stabellini@eu.citrix.com>  wrote:
>>> I had the same issue and sent a patch a while ago to fix it, adding
>>>
>>> current_state = PCI_D0 in acpiphp_glue.c:register_slot
>>>
>>> it is strange that this does not work for you:
>>>
>>> http://marc.info/?l=linux-kernel&m=129891002722845&w=2
>> So guest os has to load acpiphp instead of pciehp?
>
> maybe pciehp needs to make sure that current_state = D0 in
> pciehp_enable_slot, like acpiphp does
Here, acpi hotplugging is involved.
With your change in register_slot(), device will have proper power state when module is being loaded for the first time after booting.
However, while unload of pci module; following is in pci_device_remove():
         if (pci_dev->current_state == PCI_D0)
                 pci_dev->current_state = PCI_UNKNOWN;

So, device power state state will remain PCI_UNKNOWN while module is loaded again. Subsequently, MSI write will do nothing.

Thanks,
Ajay


