Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403Ab1LTO3F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 09:29:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52042 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694Ab1LTO25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 09:28:57 -0500
Message-ID: <1324391334.2568.9.camel@bling.home>
Subject: Re: [PATCH 1/2] kvm: Remove ability to assign a device without
 iommu support
From: Alex Williamson <alex.williamson@redhat.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>, "avi@redhat.com" <avi@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 20 Dec 2011 07:28:54 -0700
In-Reply-To: <1324372128.22797.6.camel@lappy>
References: <20111220030826.11829.9141.stgit@bling.home>
	 <20111220031947.11829.66292.stgit@bling.home>
	 <1324370959.22797.3.camel@lappy> <4EF04F54.9010500@siemens.com>
	 <1324372128.22797.6.camel@lappy>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-20 at 11:08 +0200, Sasha Levin wrote:
> On Tue, 2011-12-20 at 10:03 +0100, Jan Kiszka wrote:
> > On 2011-12-20 09:49, Sasha Levin wrote:
> > > On Mon, 2011-12-19 at 20:19 -0700, Alex Williamson wrote:
> > >> This option has no users and it exposes a security hole that we
> > >> can allow devices to be assigned without iommu protection.  Make
> > >> KVM_DEV_ASSIGN_ENABLE_IOMMU a mandatory option.
> > >>
> > >> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > >> ---
> > >>
> > >>  virt/kvm/assigned-dev.c |   18 +++++++++---------
> > >>  1 files changed, 9 insertions(+), 9 deletions(-)
> > >>
> > >> diff --git a/virt/kvm/assigned-dev.c b/virt/kvm/assigned-dev.c
> > >> index 3ad0925..a251a28 100644
> > >> --- a/virt/kvm/assigned-dev.c
> > >> +++ b/virt/kvm/assigned-dev.c
> > >> @@ -487,6 +487,9 @@ static int kvm_vm_ioctl_assign_device(struct kvm *kvm,
> > >>  	struct kvm_assigned_dev_kernel *match;
> > >>  	struct pci_dev *dev;
> > >>  
> > >> +	if (!(assigned_dev->flags & KVM_DEV_ASSIGN_ENABLE_IOMMU))
> > >> +		return -EINVAL;
> > > 
> > > Could we just drop KVM_DEV_ASSIGN_ENABLE_IOMMU and do it by default?
> > > calling KVM_ASSIGN_PCI_DEVICE without that flag set it pretty
> > > meaningless.
> > 
> > There is that thing called "backward compatibility". :)
> 
> Well, Alex suggested skipping deprecation period because there are
> currently no users of KVM_ASSIGN_PCI_DEVICE without
> KVM_DEV_ASSIGN_ENABLE_IOMMU, so it should be fine to just make it the
> default behavior, no?
> 
> We can leave KVM_DEV_ASSIGN_ENABLE_IOMMU itself so userspace won't
> break, but theres no reason to enforce it being set in the kernel code.

As Jan said, the option does have historical meaning.  Ignoring the flag
adds ambiguity to the API, so I think it's best to make it clear which
path is no longer supported.  Either way, we don't get to take the flag
back, so it might as well serve as a sanity check.  Thanks,

Alex 

