Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492Ab2HFOQq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 10:16:46 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:33664 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756475Ab2HFOQn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 10:16:43 -0400
Date: Mon, 6 Aug 2012 10:07:06 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: yinghai@kernel.org, linux-pci@vger.kernel.org, roland@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: mellanox mlx4_core and SR-IOV
Message-ID: <20120806140706.GC3093@phenom.dumpdata.com>
References: <9f903175-4080-4016-b9f8-83e8615c110e@default>
 <20120805080500.GH25979@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120805080500.GH25979@ics.muni.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 05, 2012 at 10:05:00AM +0200, Lukas Hejtmanek wrote:
> Hi,
> 
> On Fri, Aug 03, 2012 at 06:49:59AM -0700, Konrad Wilk wrote:
> > This looks like you are using PV PCI passthrough? If so, did you
> > remember to use 'iommu=soft' to enable the Xen-SWIOTLB in your guest?
> > And are you booting with more than 4GB? Or is less than 3GB (so that you have
> > a nice gap in E820).
> 
> good catch. I forgot to pass swiotl=force for DomU in Xen. So now, it seems
> that mlx4_core works, mlx4_en (ethernet part) works as well. Unfortunately,
> the IB part does not. IB layer complains that SR-IOV is currently unsupported
> (kernel 3.5.0). So no luck here so far. 

Don't use swiotlb=force. That is for the old style kernels. Use iommu=soft.
> 
> There is OFED stack directly from Mellanox, that seems to support SR-IOV even
> for IB layer, but they have buildable sources only for RHEL/SLES kernels
> (2.6.32) and even correcting the sources to get it compile with 3.5.0 does not
> make things work. The driver complains about interrupts not working in Dom0 or
> even without Xen hypervisor at all.

So there is a bug that .. well, I thought I had fixed it with the
IB layer but maybe not. It was about VM_IO having to be used on the vmaps
being setup. But I can't recall the details. Perhaps the InfiniBand mailing
list might have some ... ah here it is:
http://old-list-archives.xen.org/archives/html/xen-devel/2011-01/msg00246.html
> 
> The only good point is, that I managed to convice Supermicro (board
> manufacturer), that enabling SR-IOV in BIOS leads to BIOS lockup, they
> confirmed it and maybe they provide BIOS upgrade.
> 
> Thanks all.
> 
> -- 
> Lukáš Hejtmánek
