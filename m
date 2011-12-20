Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839Ab1LTJMZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 04:12:25 -0500
Received: from goliath.siemens.de ([192.35.17.28]:22404 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab1LTJMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 04:12:22 -0500
Message-ID: <4EF0516F.2030102@siemens.com>
Date: Tue, 20 Dec 2011 10:12:15 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: Alex Williamson <alex.williamson@redhat.com>,
        "avi@redhat.com" <avi@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] kvm: Remove ability to assign a device without iommu
 support
References: <20111220030826.11829.9141.stgit@bling.home>   <20111220031947.11829.66292.stgit@bling.home>  <1324370959.22797.3.camel@lappy> <4EF04F54.9010500@siemens.com> <1324372128.22797.6.camel@lappy>
In-Reply-To: <1324372128.22797.6.camel@lappy>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-12-20 10:08, Sasha Levin wrote:
> On Tue, 2011-12-20 at 10:03 +0100, Jan Kiszka wrote:
>> On 2011-12-20 09:49, Sasha Levin wrote:
>>> On Mon, 2011-12-19 at 20:19 -0700, Alex Williamson wrote:
>>>> This option has no users and it exposes a security hole that we
>>>> can allow devices to be assigned without iommu protection.  Make
>>>> KVM_DEV_ASSIGN_ENABLE_IOMMU a mandatory option.
>>>>
>>>> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
>>>> ---
>>>>
>>>>  virt/kvm/assigned-dev.c |   18 +++++++++---------
>>>>  1 files changed, 9 insertions(+), 9 deletions(-)
>>>>
>>>> diff --git a/virt/kvm/assigned-dev.c b/virt/kvm/assigned-dev.c
>>>> index 3ad0925..a251a28 100644
>>>> --- a/virt/kvm/assigned-dev.c
>>>> +++ b/virt/kvm/assigned-dev.c
>>>> @@ -487,6 +487,9 @@ static int kvm_vm_ioctl_assign_device(struct kvm *kvm,
>>>>  	struct kvm_assigned_dev_kernel *match;
>>>>  	struct pci_dev *dev;
>>>>  
>>>> +	if (!(assigned_dev->flags & KVM_DEV_ASSIGN_ENABLE_IOMMU))
>>>> +		return -EINVAL;
>>>
>>> Could we just drop KVM_DEV_ASSIGN_ENABLE_IOMMU and do it by default?
>>> calling KVM_ASSIGN_PCI_DEVICE without that flag set it pretty
>>> meaningless.
>>
>> There is that thing called "backward compatibility". :)
> 
> Well, Alex suggested skipping deprecation period because there are
> currently no users of KVM_ASSIGN_PCI_DEVICE without
> KVM_DEV_ASSIGN_ENABLE_IOMMU, so it should be fine to just make it the
> default behavior, no?

This iommu-less mode used to "work" for older qemu-kvm version, and I
think it should still do. Though it makes no sense, I fully agree.

Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
