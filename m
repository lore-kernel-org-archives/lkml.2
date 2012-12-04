Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193Ab2LDUFr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 15:05:47 -0500
Received: from usmamail.tilera.com ([12.216.194.151]:48540 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661Ab2LDUFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 15:05:45 -0500
Message-ID: <50BE5796.6080009@tilera.com>
Date: Tue, 4 Dec 2012 15:05:42 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Wei Yongjun <weiyj.lk@gmail.com>, <yongjun_wei@trendmicro.com.cn>,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>
Subject: Re: [PATCH -next] tile/PCI: use for_each_pci_dev to simplify the
 code
References: <CAPgLHd-GK0ZO97vhaNhFuHBxuHf+s+7YQ1kw_-+7pUVoqNwgdw@mail.gmail.com> <CAErSpo7apCKg0ADSV2w1uGsFFAWi3-E4mbf8HLW8V+Gj9YNdsg@mail.gmail.com>
In-Reply-To: <CAErSpo7apCKg0ADSV2w1uGsFFAWi3-E4mbf8HLW8V+Gj9YNdsg@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/4/2012 2:57 PM, Bjorn Helgaas wrote:
> On Mon, Dec 3, 2012 at 6:28 AM, Wei Yongjun <weiyj.lk@gmail.com> wrote:
>> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>>
>> Use for_each_pci_dev to simplify the code.
>>
>> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>> ---
>>  arch/tile/kernel/pci.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/tile/kernel/pci.c b/arch/tile/kernel/pci.c
>> index 7598226..aac1cd5 100644
>> --- a/arch/tile/kernel/pci.c
>> +++ b/arch/tile/kernel/pci.c
>> @@ -245,7 +245,7 @@ static void __devinit fixup_read_and_payload_sizes(void)
>>         u16 new_values;
>>
>>         /* Scan for the smallest maximum payload size. */
>> -       while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
>> +       for_each_pci_dev(dev) {
>>                 u32 devcap;
>>                 int max_payload;
>>
>> @@ -260,7 +260,7 @@ static void __devinit fixup_read_and_payload_sizes(void)
>>
>>         /* Now, set the max_payload_size for all devices to that value. */
>>         new_values = (max_read_size << 12) | (smallest_max_payload << 5);
>> -       while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL)
>> +       for_each_pci_dev(dev)
>>                 pcie_capability_clear_and_set_word(dev, PCI_EXP_DEVCTL,
>>                                 PCI_EXP_DEVCTL_PAYLOAD | PCI_EXP_DEVCTL_READRQ,
>>                                 new_values);
>>
>>
> This patch looks correct to me, as far as it goes.
>
> Of course, any time we use for_each_pci_dev(), it's a good clue that
> this code won't work for hotplug, so presumably you don't care about
> hotplug on this system.

Hotplug development is under way at the moment.

> tile/kernel/pci_gx.c has a function of the same name, implemented
> completely differently, which suggests that some unification or
> refactoring might be possible.

Sorry, which function are you referring to?  You mention MPS/MRS so perhaps you're talking about fixup_read_and_payload_sizes()?

> In general, I think the PCI_EXP_DEVCAP and PCI_EXP_DEVCTL code for MPS
> and MRRS management belongs in the PCI core, not in drivers or
> architectures (it's fine if they provide device- or platform-specific
> constraints), so anything you can do to move in that direction would
> be good.
>
> Bjorn

Thanks!

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

