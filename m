Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757027Ab0FAWuU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 18:50:20 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:43294 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605Ab0FAWuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 18:50:18 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Mike Travis <travis@sgi.com>
Subject: Re: [Patch 1/1] x86 pci: Add option to not assign BAR's if not already assigned
Date: Tue, 1 Jun 2010 16:49:55 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; x86_64; ; )
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jacob Pan <jacob.jun.pan@intel.com>, Tejun Heo <tj@kernel.org>,
       Mike Habeck <habeck@sgi.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
References: <4BEAF008.9030805@sgi.com> <4C0021DC.60608@zytor.com> <4C039980.3020608@sgi.com>
In-Reply-To: <4C039980.3020608@sgi.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201006011649.56074.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re-added linux-pci, which got lost again somewhere.]

On Monday, May 31, 2010 05:12:00 am Mike Travis wrote:
> H. Peter Anvin wrote:
> > On 05/28/2010 10:10 AM, Mike Travis wrote:
> >> H. Peter Anvin wrote:
> >>> On 05/28/2010 09:53 AM, Mike Travis wrote:
> >>>> Any further consideration for this patch, or has it been rejected?

I'm disappointed that you didn't rework this to make it generic,
not x86-specific.  That would be pretty easy and would remove
the need for somebody else to come and clean it up later.

> >>> Well, it's really up to Jesse, but as far as I can see, this patch is a
> >>> net loss of functionality and doesn't actually add anything.  Without
> >>> this patch, some resources that were not assigned by BIOS will be
> >>> unreachable.  With this patch, *all* resources that were not assigned by
> >>> BIOS will be unreachable...
> >>>
> >>> 	-hpa
> >>>
> >> Apparently you're missing the point of the patch?  The patch is needed
> >> because BIOS is purposely not assigning I/O BAR's to devices that won't
> >> use them, freeing up the resource for devices that do need them.  Where
> >> is the "all" resources that are not reachable?
> > 
> > No, the patch isn't needed for those.
> > 
> > Without your patch:
> > 
> > - Devices assigned by BIOS remain assigned;
> > - Devices not assigned by BIOS get assigned until address space
> >   exhausted.
> > 
> > With your patch:
> > 
> > - Devices assigned by BIOS remain assigned;
> > - Devices not assigned by BIOS never get assigned at all.
> > 
> > What am I missing here?
> 
> BIOS still assigns the MMIO BAR's so the devices are alive.

I'm sorry; I don't follow this.  BIOS assigns MMIO BARs regardless
of whether we have your patch.

I'm still having trouble reconciling the stated purpose, i.e., the
changelog, with the behavior.  The changelog implies that the patch
is required to make >16 devices with I/O BARs work at all, but per
Mike Habeck, the patch just gets rid of some warnings and maybe helps
with hot-add of devices using I/O space.

Is there a deeper problem that happens if we exhaust I/O space?
Are we releasing device resources in pci_assign_unassigned_bridge_resources()
and then we fail to reassign even MMIO resources after we exhaust
I/O space?

Maybe a complete dmesg log showing the failure would be helpful.  if
so, you could open a kernel.org bugzilla and reference it in your
changelog so we can take this issue into account in future PCI work.

Bjorn
