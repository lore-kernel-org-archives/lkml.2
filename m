Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756955Ab2JJSU6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 14:20:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47604 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756881Ab2JJSU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 14:20:57 -0400
MIME-Version: 1.0
In-Reply-To: <20121010165110.GB2506@amt.cnet>
References: <1349742971.2674.75.camel@lorien2>
	<20121010165110.GB2506@amt.cnet>
Date: Wed, 10 Oct 2012 12:20:56 -0600
Message-ID: <CAKocOON7qU08eUyd=mqMhFT0TBCwZS5X+8uxutKn+0AuCxW_Zw@mail.gmail.com>
Subject: Re: [PATCH] virt/kvm: change kvm_assign_device() to print return
 value when iommu_attach_device() fails
From: Shuah Khan <shuahkhan@gmail.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Shuah Khan <shuah.khan@hp.com>, avi@redhat.com, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 10:51 AM, Marcelo Tosatti <mtosatti@redhat.com> wrote:
> On Mon, Oct 08, 2012 at 06:36:11PM -0600, Shuah Khan wrote:
>> Change existing kernel error message to include return value from
>> iommu_attach_device() when it fails. This will help debug device
>> assignment failures more effectively.
>>
>> Signed-off-by: Shuah Khan <shuah.khan@hp.com>
>> ---
>>  virt/kvm/iommu.c |    6 +-----
>>  1 file changed, 1 insertion(+), 5 deletions(-)
>>
>> diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
>> index 037cb67..18e1e30 100644
>> --- a/virt/kvm/iommu.c
>> +++ b/virt/kvm/iommu.c
>> @@ -168,11 +168,7 @@ int kvm_assign_device(struct kvm *kvm,
>>
>>       r = iommu_attach_device(domain, &pdev->dev);
>>       if (r) {
>> -             printk(KERN_ERR "assign device %x:%x:%x.%x failed",
>> -                     pci_domain_nr(pdev->bus),
>> -                     pdev->bus->number,
>> -                     PCI_SLOT(pdev->devfn),
>> -                     PCI_FUNC(pdev->devfn));
>> +             dev_err(&pdev->dev, "kvm assign device failed ret %d", r);
>>               return r;
>>       }
>
> Why removal of domain,bus,slot,func from the message?
>

dev_err() includes that information like this:

pci 0000:00:1d.0: assign device failed ret 0

Without the removal of domain,bus,slot,func from the message:

It will look like:

pci 0000:00:1d.0: assign device 0:0:1d.0 failed ret 0

Initially I left it in there and after testing, realized it is
duplicate information and decided to remove it.

-- Shuah
