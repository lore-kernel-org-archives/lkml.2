Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197Ab2JJTK7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 15:10:59 -0400
Received: from adoakley.name ([46.4.104.242]:53421 "EHLO ado.is-a-geek.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757159Ab2JJTK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 15:10:58 -0400
Date: Wed, 10 Oct 2012 20:11:31 +0100
From: Andrew Oakley <andrew@ado.is-a-geek.net>
To: Joerg Roedel <joro@8bytes.org>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [git pull] IOMMU Updates for v3.7-rc1
Message-ID: <20121010201131.091d5a1f@ado-amd-gentoo.moore.slainvet.net>
In-Reply-To: <20121010133249.GC16151@8bytes.org>
References: <20121005152312.GA4649@8bytes.org>
	<20121009224532.1e515664@ado-amd-gentoo.moore.slainvet.net>
	<20121010073022.GB16151@8bytes.org>
	<20121010095823.140fdd98@ado-amd-gentoo.moore.slainvet.net>
	<20121010133249.GC16151@8bytes.org>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.12; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Oct 2012 15:32:49 +0200
Joerg Roedel <joro@8bytes.org> wrote:

> On Wed, Oct 10, 2012 at 09:58:23AM +0100, Andrew Oakley wrote:
> > On Wed, 10 Oct 2012 09:30:22 +0200
> > Joerg Roedel <joro@8bytes.org> wrote:
> 
> > AMD-Vi:   DEV_SPECIAL(IOAPIC[2])		devid: 00:00.1
> 
> Okay, got it. This is the problem. The device id seems to be wrong.
> The BIOS should configure your IOAPIC as device id 00:14.0 and not
> 00:00.1. The current checking code does not check for this particular
> situation. But the attached diff should change that. Can you please
> test it and reports if the machine boots for you? Interrupt remapping
> will be disabled automatically, though.

Yes, that detects the problem and disables the interrupt remapping (the
kernel boots).

If I modify the devid for the IOAPIC in init_iommu_from_acpi then it
also seems to work.  I haven't managed to get vfio/qemu working yet but
it seems to be unrelated ("Invalid ROM contents", same thing happens
when I try to dump the rom with stable kernels).

Thanks

-- 
Andrew Oakley
