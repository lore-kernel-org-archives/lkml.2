Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757093Ab2HTP1E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 11:27:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64146 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757077Ab2HTP06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 11:26:58 -0400
Message-ID: <50325732.3000700@gmail.com>
Date: Mon, 20 Aug 2012 23:26:42 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Don Dutile <ddutile@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH v3 00/32] provide interfaces to access PCIe capabilities
 registers
References: <1343836477-7287-1-git-send-email-jiang.liu@huawei.com> <CAErSpo7WoEeWayMQ__H4jiKKmMdNgyLMYdRmJ0Nf0LoEKjFRmA@mail.gmail.com>
In-Reply-To: <CAErSpo7WoEeWayMQ__H4jiKKmMdNgyLMYdRmJ0Nf0LoEKjFRmA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2012 12:25 PM, Bjorn Helgaas wrote:
> On Wed, Aug 1, 2012 at 8:54 AM, Jiang Liu <liuj97@gmail.com> wrote:
>> From: Jiang Liu <liuj97@gmail.com>
>>
>> As suggested by Bjorn Helgaas and Don Dutile in threads
>> http://www.spinics.net/lists/linux-pci/msg15663.html, we could improve access
>> to PCIe capabilities register in to way:
>> 1) cache content of PCIe Capabilities Register into struct pce_dev to avoid
>>    repeatedly reading this register because it's read only.
>> 2) provide access functions for PCIe Capabilities registers to hide differences
>>    among PCIe base specifications, so the caller don't need to handle those
>>    differences.
>>
>> This patch set applies to
>> git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git pci-next
> 
> Would you mind rebasing this to v3.6-rc1?  I think you posted this
> when my branch was still 3.5-based, and there are some upstream
> changes that cause minor conflicts here.
> 
> You currently have:
> 
>     int pci_pcie_capability_change_word(struct pci_dev *dev, int pos,
> u16 set_bits, u16 clear_bits)
> 
> I think this is a bit awkward because the function name doesn't
> suggest *how* the word will be changed, and the clearing happens
> before the setting (opposite the parameter order).  Something like:
> 
>     int pci_pcie_capability_mask_and_set_word(..., u16 mask, u16 set) or
>     int pci_pcie_capability_clear_and_set_word(..., u16 clear, u16 set)
> 
> would be more obvious.  If you use "mask_and_set", I think the
> function should do "(val & mask) | set" with the complement being at
> the call site.  If you use "clear_and_set", I think it's OK to do
> "(val & ~mask) | set" as in your current patch.
> 
> I know I suggested the "pci_pcie_capability_*" names, but they're
> getting a bit unwieldy, especially if we do "mask_and_set" or similar.
>  There are already several "pcie_*" functions, so maybe we should
> drop the leading "pci_" from these and just have:
> 
>     pcie_capability_read_word
>     pcie_capability_write_word
>     pcie_capability_mask_and_set_word
> 
> Bjorn
> 
Hi Bjorn,
	I have made following changes according to your suggestions,
	1) get rid of the "pci_" prefix for access functions.
	2) rename pci_pcie_capability_change_{word|dword}() to
	pcie_capability_clear_and_set_{word|dword}.
	3) add pcie_capability_{set|clear}_{word|dword}().
	4) Add "Acked-by" and "Reviewed-by"
	5) rebase to your latest pci-next tree

	So could you please help to pull from "https://github.com/jiangliu/linux.git topic/pcie-cap"
or should I send all the patches to mail list again?

	Regards!
	Gerry

