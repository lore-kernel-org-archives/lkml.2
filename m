Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933226Ab2FGWJL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 18:09:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16356 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933098Ab2FGWJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 18:09:09 -0400
Message-ID: <1339106941.26976.51.camel@ul30vt>
Subject: Re: [PATCH] PCI: Add Ralink RT2800 broken INTx masking quirk
From: Alex Williamson <alex.williamson@redhat.com>
To: Andreas Hartmann <andihartmann@01019freenet.de>
Cc: bhelgaas@google.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        jan.kiszka@siemens.com
Date: Thu, 07 Jun 2012 16:09:01 -0600
In-Reply-To: <4FD1205D.8070501@01019freenet.de>
References: <20120606212241.6627.98371.stgit@bling.home>
	   <4FD047A7.6050602@01019freenet.de> <1339088741.26976.19.camel@ul30vt>
	  <201206072101.q57L1LqG003192@mail.maya.org>
	 <1339104327.26976.45.camel@ul30vt> <4FD1205D.8070501@01019freenet.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-07 at 23:42 +0200, Andreas Hartmann wrote:
> Alex Williamson wrote:
> > On Thu, 2012-06-07 at 23:01 +0200, Andreas Hartmann wrote:
> >> Alex Williamson wrote:
> >>> On Thu, 2012-06-07 at 08:18 +0200, Andreas Hartmann wrote:
> >>>> Hello Alex,
> >>>>
> >>>> what about a module parameter to achieve this behaviour manually by
> >>>> the user without recompiling? I fear, there are much more candidates
> >>>> out there needing this "feature".
> >>>
> >>> Yeah, that's probably a good idea.  For debugging and letting users have
> >>> a workaround rather than any kind of regular use.  I'll add a nointxmask
> >>> to vfio-pci with a description indicating that if it fixes a device to
> >>> report it for quirking.
> >>
> >> That's exactly what I meant.
> >>
> >>
> >> May I have please another question? 
> >> Unfortunately I can't cleanly unmount filesystems during shutdown with your 
> >> kernel (this problem doesn't happen with the patched 3.4 suse kernel).
> > 
> > Hmm, are you using my kernel that's based on the next branch?  Could be
> > any number of things broken in next.
> > 
> >> I applied your vfio-patches from your git-repository to an openSUSE 3.4 
> >> kernel (plus one other to get the patches applied):
> >>
> >> iommu_core:_pass_a_user-provided_token_to_fault_handlers.patch
> >> 0ca4120cbaeaa2aecdccc5043b309fe1808aae2a.patch [PATCH] pci: Add PCI DMA source ID quirk
> >> db47c1f7313ad863818261f62f1babaf0b564e55.patch [PATCH] pci: Add ACS validation utility
> >> a89edb6943102d4519860bca5671740c1b7364cc.patch [PATCH] pci: export pci_user functions for use by other drivers
> >> 38fdda7327b6cf50c1265a6332e94b97100aa10e.patch [PATCH] pci: Create common pcibios_err_to_errno
> >> cb6e045625e5a217df3cebcb4585b40cbcad6c96.patch [PATCH] pci: Misc pci_reg additions
> >> c6985f9b501903f5c707a1711fa53dc94c72f999.patch [PATCH] driver core: Add iommu_group tracking to struct device
> >> 581187e853620c52e4b78db643161cc3be2f3388.patch [PATCH] iommu: IOMMU Groups
> >> 635e48574089f4c8205a2fd7b1d85edd02344fe5.patch [PATCH] amd_iommu: Support IOMMU groups
> >> 37f2d6d5217fdd2facd9641b83fde683263adcaf.patch [PATCH] intel-iommu: Support IOMMU groups
> >> 351d849a51787140736e04f261ae9db09c980868.patch [PATCH] amd_iommu: Make use of DMA quirks and ACS checks in IOMMU
> >> 92eef0a72193ef8504eea10b4ccbdb2e1ee9f4b3.patch [PATCH] intel-iommu: Make use of DMA quirks and ACS checks in IOMMU groups
> >> dd2886fe0a8936d649a365162658406e7a18d274.patch [PATCH] iommu: Remove group_mf
> >> 6891b9a7d56841e592cfb444a7f4b2b02831f866.patch [PATCH] vfio: VFIO core
> >> 51b06ff680d8bc30d1bd627e2dd24641789be55d.patch [PATCH] vfio: Add documentation
> >> 4b36b306122a225d33e947e7f9e6d1117a4fb699.patch [PATCH] vfio: Type1 IOMMU implementation
> >> 91e4950e482b142dd9ab46f0ec386c5eed9f1470.patch [PATCH] vfio: Add PCI device driver
> >> PCI:_Mark_INTx_masking_support_of_Chelsio_T310_10GbE_NIC_as_broken.patch 
> >> PCI:_Add_Ralink_RT2800_broken_INTx_masking_quirk.patch 
> >> IRQF_ONESHOT.patch"
> >>
> >>
> >> The VM does work as expected, but fglrx isn't happy any
> >> more (but worked fine with your kernel and works fine, too, with the
> >> unpatched suse 3.4 kernel). fglrx says:
> > 
> > So you're saying:
> > 
> > kernel built from my tree: fglrx works
> > opensuse kernel: fglrx works
> > opensuse kernel + above patches: failure below?
> 
> Exactly.
> 
> > 
> >> Jun  7 14:21:42 host kernel: [  105.103610] [fglrx:firegl_cail_init] *ERROR* CAIL: CAILInitialize failed, error 1
> >> Jun  7 14:21:42 host kernel: [  105.103613] [fglrx:hal_init_asic] *ERROR* Failed to initialize ASIC.
> >> Jun  7 14:21:42 host kernel: [  105.103645] [fglrx:firegl_init_pcie] *ERROR* Can not get FB size
> >> Jun  7 14:21:42 host kernel: [  105.103653] [fglrx:IRQMGR_alloc_context] *ERROR* IRQMGR_GetExtensionSize returned 0
> >> Jun  7 14:21:42 host kernel: [  105.103654] [fglrx:irqmgr_wrap_initialize] *ERROR* Fail to allocate IRQMGR context! 
> >> Jun  7 14:21:42 host kernel: [  105.109151] [fglrx:firegl_irq_enable] *ERROR* interrupt source ff000032 is not supported on this hardware (return code = 2)
> >> Jun  7 14:21:42 host kernel: [  105.109173] [fglrx:firegl_irq_enable] *ERROR* interrupt source 10000000 is not supported on this hardware (return code = 2)
> >> Jun  7 14:21:42 host kernel: [  105.169073] [fglrx:firegl_irq_enable] *ERROR* interrupt source 60000001 is not supported on this hardware (return code = 2)
> >> Jun  7 14:21:42 host kernel: [  105.169107] [fglrx:firegl_irq_enable] *ERROR* interrupt source ff00002c is not supported on this hardware (return code = 2)
> >> Jun  7 14:21:42 host kernel: [  105.169125] [fglrx:firegl_irq_enable] *ERROR* interrupt source ff00004e is not supported on this hardware (return code = 2)
> >> Jun  7 14:21:42 host kernel: [  105.169142] [fglrx:firegl_irq_enable] *ERROR* interrupt source 20000400 is not supported on this hardware (return code = 2)
> >> Jun  7 14:21:42 host kernel: [  105.172906] [fglrx:firegl_cmmqs_init] *ERROR* CMMQS init:GAL is not initialized.
> >> Jun  7 14:21:42 host kernel: [  105.172909] [fglrx:firegl_cmmqs_createdriver] *ERROR* CMMQS Initialization failed: firegl_cmmqs_createdriver
> >> Jun  7 14:21:42 host kernel: [  105.172940] [fglrx:firegl_cmmqs_BIOSControl] *ERROR* CMMQS BIOS Control: CMMQS handle is not valid.
> >> Jun  7 14:21:42 host kernel: [  105.172942] [fglrx:firegl_bios_control] *ERROR* CMMQS BIOS Control is failed: firegl_bios_control
> >> Jun  7 14:21:42 host kernel: [  105.195648] AMD-Vi: Event logged [IO_PAGE_FAULT device=01:00.0 domain=0x0017 address=0x0000000f00268a00 flags=0x0010]
> >> Jun  7 14:21:42 host kernel: [  105.195651] AMD-Vi: Event logged [IO_PAGE_FAULT device=01:00.0 domain=0x0017 address=0x0000000f0026a300 flags=0x0010]
> >> ...
> >>
> >> Do you have by chance an idea which other patch is missing to get
> >> it working again?
> > 
> > Does this happen regardless of whether you've done anything with a VM or
> > even loaded the vfio modules?
> 
> vfio modules aren't loaded at all at this moment. They cannot be the
> problem ... . But there are some changes in iommu, too, aren't there?

Yes, we're creating the iommu groups.

> >  If so, please bisect the patch set and
> > report where it starts to fail.  None of these patches should have any
> > effect on existing DMA paths or drivers.  Testing stock v3.4 vs 3.4 +
> > patches would also be an interesting exercise. 
> 
> Yes, this is the next thing I have to do.

I just pushed a vfio-3.4 branch to my tree at
git://github.com/awilliam/linux-vfio.git.  Please let me know what you
find with this.  Thanks,

Alex


