Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140Ab2DPIPG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 04:15:06 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:52032 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab2DPIPD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 04:15:03 -0400
MIME-Version: 1.0
In-Reply-To: <20120413060626.GA7856@alex-p.amd.com>
References: <4F8790F6.5080408@intel.com>
	<20120413060626.GA7856@alex-p.amd.com>
Date: Mon, 16 Apr 2012 16:15:01 +0800
Message-ID: <CAC=cRTOiHkkR5r+BVv8BRaN+mwqhRJ1dfYq-3Xw8ui0x1wOOoQ@mail.gmail.com>
Subject: Re: [RFC PATCH] PCIe: Add PCIe runtime D3cold support
From: huang ying <huang.ying.caritas@gmail.com>
To: Alex He <alex.he@amd.com>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, bhelgaas@google.com, rjw@sisk.pl,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2012 at 2:06 PM, Alex He <alex.he@amd.com> wrote:
> On Fri, Apr 13, 2012 at 10:35:34AM +0800, Yan, Zheng wrote:
[snip]
>> @@ -750,7 +750,8 @@ int pci_set_power_state(struct pci_dev *dev, pci_power_t state)
>>       if (state == PCI_D3hot && (dev->dev_flags & PCI_DEV_FLAGS_NO_D3))
>>               return 0;
>>
>> -     error = pci_raw_set_power_state(dev, state);
>> +     error = pci_raw_set_power_state(dev, state > PCI_D3hot ?
>> +                                     PCI_D3hot : state);
> Do you want to set the pci device to D3hot if the state = D3Code through
> PMCSR register?

Yes.

> I am agree if you realy want that but what is the meaninig
> to distingulish D3cold with D3hot in this patch. We can't put the PCI device
> through PMCSR register.

Yes.  We put PCI device into D3hot via PMCSR firstly, then we use ACPI
_PS3 and _PR3 to put device into D3cold.

Best Regards,
Huang Ying
