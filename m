Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667Ab1FGPlP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 11:41:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21809 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588Ab1FGPlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 11:41:13 -0400
Subject: Re: Seeing DMAR errors after multiple load/unload with SR-IOV
From: Alex Williamson <alex.williamson@redhat.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Chris Wright <chrisw@sous-sol.org>,
        padmanabh ratnakar <pratnakarlx@gmail.com>,
        iommu <iommu@lists.linux-foundation.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Date: Tue, 07 Jun 2011 09:40:29 -0600
In-Reply-To: <1307460801.24181.51.camel@i7.infradead.org>
References: <BANLkTi=q0f8aYc2+fhaY5yFRRfgkOOME-g@mail.gmail.com>
	 <1307398661.5901.14.camel@x201>
	 <20110606223451.GW23047@sequoia.sous-sol.org>
	 <BANLkTintUEWqwhUmR2MYC0jixqEi-wNJpg@mail.gmail.com>
	 <20110607133804.GX23047@sequoia.sous-sol.org>
	 <1307454415.24181.46.camel@i7.infradead.org>
	 <20110607151032.GZ23047@sequoia.sous-sol.org>
	 <1307460801.24181.51.camel@i7.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1307461231.5901.20.camel@x201>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-07 at 16:33 +0100, David Woodhouse wrote:
> On Tue, 2011-06-07 at 08:10 -0700, Chris Wright wrote:
> > * David Woodhouse (dwmw2@infradead.org) wrote:
> > > On Tue, 2011-06-07 at 06:38 -0700, Chris Wright wrote:
> > > > I think we still leak the list entry though.  Bottom line is that we
> > > > need to handle hotplug ADD_DEVICE and DEL_DEVICE notifications.  We
> > > > happen to pick up ADD_DEVICE by accident, but it's all pretty sloppy. 
> > > 
> > > Yeah, keeping a list of possible stale 'pci_dev' pointers is stupid. We
> > > should figure out the matching DMAR unit directly from the ACPI table at
> > > ADD_DEVICE time, and store it in pdev->archdata.iommu.
> > > 
> > > I saw patches which were going in that direction...
> > 
> > Cool, where are they?  I'm working on something similar, and missed them.
> 
> [PATCH] pci, dmar: Update dmar units devices list during hotplug
> 
> Alex was working on it.

Nope, I had a wip patch that did an on-the-fly lookup, that I handed off
to Yinghai, but it didn't actually work.  That's when the suggestion was
made to do it at hotplug, but I'm not pursuing that right now, maybe
Yinghai is?  Thanks,

Alex

Alex

