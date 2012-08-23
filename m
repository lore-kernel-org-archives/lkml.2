Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751351Ab2HWQMh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 12:12:37 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:34012 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786Ab2HWQMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 12:12:34 -0400
MIME-Version: 1.0
In-Reply-To: <50364641.8010000@gmail.com>
References: <20120823004604.GA2882@localhost> <503587F4.3090907@huawei.com> <50364641.8010000@gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 23 Aug 2012 10:12:13 -0600
Message-ID: <CAErSpo6MepO=Ms+WBqfJmcGH0oZBJbnuYNuswavcF+mdqs2uZw@mail.gmail.com>
Subject: Re: Unable to mount NFSROOT: pcie change breaks e1000?
To: Jiang Liu <liuj97@gmail.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 9:03 AM, Jiang Liu <liuj97@gmail.com> wrote:
> Hi Bjorn,
>         Could you please help to fold this small patch into
> "[5/40] PCI/core: Use PCI Express Capability accessors"?
> It fixes a bug reported by Fengguang.

Thanks, I folded it in.  I looked briefly at whether a similar fix is
needed in pci_restore_pcie_state().  I don't *think* so, but it
wouldn't hurt for you to also double-check and let me know if it does.

Bjorn

> On 08/23/2012 09:31 AM, Jiang Liu wrote:
>> Hi Fengguang,
>>       Could you please help to verify whether following patch
>> fixes the issue?
>>       Thanks!
>>
>> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
>> index f6b491b..fac08f5 100644
>> --- a/drivers/pci/pci.c
>> +++ b/drivers/pci/pci.c
>> @@ -842,6 +842,9 @@ static int pci_save_pcie_state(struct pci_dev *dev)
>>         struct pci_cap_saved_state *save_state;
>>         u16 *cap;
>>
>> +       if (!pci_is_pcie(dev))
>> +               return 0;
>> +
>>         save_state = pci_find_saved_cap(dev, PCI_CAP_ID_EXP);
>>         if (!save_state) {
>>                 dev_err(&dev->dev, "buffer not found in %s\n", __func__);
>>
>> On 2012-8-23 8:46, Fengguang Wu wrote:
>>> buffer not found
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
