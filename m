Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330Ab2LMQXQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 11:23:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14078 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755471Ab2LMQXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 11:23:14 -0500
Message-ID: <1355415792.2229.7.camel@ul30vt.home>
Subject: Re: DMAR and DRHD errors[DMAR:[fault reason 06] PTE Read access is
 not set] Vt-d & intel_iommu
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gao <pkill.2012@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
        kvm <kvm@vger.kernel.org>
Date: Thu, 13 Dec 2012 09:23:12 -0700
In-Reply-To: <CANmqhJAuLoi_Y2Hsz+UnddHXYd9TCW-7qxp3fybDayfh33Y3Zg@mail.gmail.com>
References: <CANmqhJAuLoi_Y2Hsz+UnddHXYd9TCW-7qxp3fybDayfh33Y3Zg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-12-13 at 17:50 +0800, Jason Gao wrote:
> Dear List:
> 
> Description of problem:
> After installed Centos 6.3(RHEL6.3) on my Dell R710(lastest
> bios:Version: 6.3.0,Release Date: 07/24/2012) server,and updated
> lastest kernel "2.6.32-279.14.1.el6.x86_64",I want to use the Intel
> 82576 ET Dual Port nic's SR-IOV feature,assigning VFs to kvm guest
> 
> appended kernel boot parameter: intel_iommu=on,after boot with the
> following messages:
> 
> Dec 13 16:58:15 2 kernel: DRHD: handling fault status reg 2
> Dec 13 16:58:15 2 kernel: DMAR:[DMA Read] Request device [03:00.0]
> fault addr ffe65000
> Dec 13 16:58:15 2 kernel: DMAR:[fault reason 06] PTE Read access is not set
> Dec 13 16:58:15 2 kernel: DRHD: handling fault status reg 102
> Dec 13 16:58:15 2 kernel: DMAR:[DMA Read] Request device [03:00.0]
> fault addr ffe8a000
> Dec 13 16:58:15 2 kernel: DMAR:[fault reason 06] PTE Read access is not set
> Dec 13 16:58:15 2 kernel: scsi 0:0:32:0: Enclosure         DP
> BACKPLANE        1.07 PQ: 0 ANSI: 5
> Dec 13 16:58:15 2 kernel: DRHD: handling fault status reg 202
> Dec 13 16:58:15 2 kernel: DMAR:[DMA Read] Request device [03:00.0]
> fault addr ffe89000
> Dec 13 16:58:15 2 kernel: DMAR:[fault reason 06] PTE Read access is not set
> 
> full dmesg detail:
>    http://pastebin.com/BzFQV0jU
> lspci -vvv full detail:
>    http://pastebin.com/9rP2d1br
> 
> 
> it's a production server,and I'm not sure if this is a critical
> problem,how to fix it,any help would be greatly appreciated.

Device 03:00.0 is your raid controller:

03:00.0 RAID bus controller: LSI Logic / Symbios Logic MegaRAID SAS 1078 (rev 04)

For some reason it's trying to read from ffe65000, ffe8a000, ffe89000,
ffe86000, ffe87000, ffe84000.  Those are in reserved memory regions, so
it's not reading an OS allocated buffer, which probably means it's some
kind of side-band communication with a management controller.  I'd guess
it's a BIOS bug and there should be an RMRR covering those accesses.
Thanks,

Alex

