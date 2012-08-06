Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184Ab2HFPKz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 11:10:55 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:52140 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932153Ab2HFPKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 11:10:53 -0400
Date: Mon, 6 Aug 2012 17:10:43 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: yinghai@kernel.org, linux-pci@vger.kernel.org, roland@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: mellanox mlx4_core and SR-IOV
Message-ID: <20120806151043.GY25979@ics.muni.cz>
References: <9f903175-4080-4016-b9f8-83e8615c110e@default>
 <20120805080500.GH25979@ics.muni.cz>
 <20120806140706.GC3093@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120806140706.GC3093@phenom.dumpdata.com>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Muni-Spam-TestIP: 147.251.17.147
X-Muni-Envelope-From: xhejtman@ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Mon, 06 Aug 2012 17:10:45 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2012 at 10:07:06AM -0400, Konrad Rzeszutek Wilk wrote:
> > good catch. I forgot to pass swiotl=force for DomU in Xen. So now, it seems
> > that mlx4_core works, mlx4_en (ethernet part) works as well. Unfortunately,
> > the IB part does not. IB layer complains that SR-IOV is currently unsupported
> > (kernel 3.5.0). So no luck here so far. 
> 
> Don't use swiotlb=force. That is for the old style kernels. Use iommu=soft.

OK.

> > There is OFED stack directly from Mellanox, that seems to support SR-IOV even
> > for IB layer, but they have buildable sources only for RHEL/SLES kernels
> > (2.6.32) and even correcting the sources to get it compile with 3.5.0 does not
> > make things work. The driver complains about interrupts not working in Dom0 or
> > even without Xen hypervisor at all.
> 
> So there is a bug that .. well, I thought I had fixed it with the
> IB layer but maybe not. It was about VM_IO having to be used on the vmaps
> being setup. But I can't recall the details. Perhaps the InfiniBand mailing
> list might have some ... ah here it is:
> http://old-list-archives.xen.org/archives/html/xen-devel/2011-01/msg00246.html

not sure what do you mean. This fix is for Mellanox OFED driver to work? Or for stock kernel?
Stock kernel contains explicit check for SR-IOV and refuses to load.

this is exact fail of the Mellanox OFED driver.

kernel: [    6.568433] mlx4_core: Mellanox ConnectX core driver v1.0-mlnx_ofed1.5.3 (November 3, 2011)
kernel: [    6.568526] mlx4_core: Initializing 0000:02:00.0
kernel: [    7.071292] mlx4_core 0000:02:00.0: Enabling sriov with:1 vfs
kernel: [    7.175587] mlx4_core 0000:02:00.0: Running in master mode
kernel: [   18.613383] mlx4_core 0000:02:00.0: command 0x31 timed out (go bit not cleared)
kernel: [   18.613475] mlx4_core 0000:02:00.0: NOP command failed to generate MSI-X interrupt IRQ 94).
kernel: [   18.613564] mlx4_core 0000:02:00.0: Trying again without MSI-X.
kernel: [   28.606086] mlx4_core 0000:02:00.0: command 0x31 timed out (go bit not cleared)
kernel: [   30.615093] mlx4_core: probe of 0000:02:00.0 failed with error -16


-- 
Luká¹ Hejtmánek
