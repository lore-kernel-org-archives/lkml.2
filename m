Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242Ab3AIQdE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 11:33:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16781 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932193Ab3AIQdC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 11:33:02 -0500
Message-ID: <50ED9BAC.50700@redhat.com>
Date: Wed, 09 Jan 2013 11:32:44 -0500
From: Don Dutile <ddutile@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120601 Thunderbird/10.0.5
MIME-Version: 1.0
To: Tadeusz Struk <tadeusz.struk@intel.com>
CC: bhelgaas@google.com, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH] PCI: Make pci_find_upstream_pcie_bridge() handle non
 PCIE VFs well
References: <50ec2e19.EUrQfXEnsRJiPCTv%tadeusz.struk@intel.com> <50EC51E3.6070306@redhat.com> <50ED4615.1040204@intel.com>
In-Reply-To: <50ED4615.1040204@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2013 05:27 AM, Tadeusz Struk wrote:
> On 01/08/2013 05:05 PM, Don Dutile wrote:
>
>> (a) no such thing as a non-PCIe VF -- all VFs
>>      are PCIe-based.
>
> The sriov spec says that a VF doesn't necessarily has to have PCIE cap:
> "3.5 PCI Express Capability:
>     ...
>     PFs and VFs are required to implement this capability ... subject to
>     the exceptions and additional requirements described below"
>
>> (b) code says to return null if VF doesn't have PCIe cap,
>>      but the code checks if pdev is VF and if PF is PCIe,
>>      which it must be! ...
>
> You are right, I should rather check if the VF is not a pcie.
>
Again -- nack! -- SRIOV devices must be PCIe.
Virtualization support expects VFs to be PCIe-based,
and supports things like:
(a) FLR
(b) dev-id tagged source packetting for DMA/IOMMU-mapping/filtering
(c) MSI/MSI-X only
  etc....

>> nack until a better&/or matching explanation of what
>> the real problem is, and what the solution is trying to do.
>
> The problem is that I do have a device where VFs are not PCIE and I get this nasty warning.
> For now I have a workaround, but it would be nice it Linux would support non PCIE VFs.
>
This is a violation of the SRIOV spec.
I do not see how we'll take a patch for violating a core specification,
and then expecting us to hack the core sriov support for it.
At best, a quirk-like hack would be entertained.

Why is this call needed by your VF (or PF) driver ?

> Thanks,
> T
>

