Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743Ab0HCNuk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 09:50:40 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:36753 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756509Ab0HCNui (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 3 Aug 2010 09:50:38 -0400
Date: Tue, 3 Aug 2010 09:49:47 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Xen Devel <Xen-devel@lists.xensource.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        Konrad@rcsinet12.oracle.com, Sheng Yang <sheng@linux.intel.com>
Subject: Re: [Xen-devel] linux-next: manual merge of the xen tree with the
 swiotlb tree
Message-ID: <20100803134947.GC4751@phenom.dumpdata.com>
References: <20100803141351.cd70beca.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100803141351.cd70beca.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4C581EA1.0287:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 02:13:51PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the xen tree got a conflict in
> drivers/xen/Kconfig drivers/xen/Makefile between commit
> b097186fd29d5bc5a26d1ae87995821ffc27b66e ("swiotlb-xen: SWIOTLB library
> for Xen PV guest with PCI passthrough") from the swiotlb tree and commit
> 183d03cc4ff39e0f0d952c09aa96d0abfd6e0c3c ("xen: Xen PCI platform device
> driver") from the xen tree.
> 
> Just overlapping additions.  I fixed it up (see below) and can carry the
> fix as necessary.

Thank you!
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc drivers/xen/Kconfig
> index 97199c2,0a88269..0000000
> --- a/drivers/xen/Kconfig
> +++ b/drivers/xen/Kconfig
> @@@ -62,8 -62,13 +62,18 @@@ config XEN_SYS_HYPERVISO
>   	 virtual environment, /sys/hypervisor will still be present,
>   	 but will have no xen contents.
>   
>  +config SWIOTLB_XEN
>  +	def_bool y
>  +	depends on SWIOTLB
>  +
> + config XEN_PLATFORM_PCI
> + 	tristate "xen platform pci device driver"
> + 	depends on XEN_PVHVM
> + 	default m
> + 	help
> + 	  Driver for the Xen PCI Platform device: it is responsible for
> + 	  initializing xenbus and grant_table when running in a Xen HVM
> + 	  domain. As a consequence this driver is required to run any Xen PV
> + 	  frontend on Xen HVM.
> ++
>   endmenu
> diff --cc drivers/xen/Makefile
> index 85f84cf,e392fb7..0000000
> --- a/drivers/xen/Makefile
> +++ b/drivers/xen/Makefile
> @@@ -10,4 -10,4 +10,5 @@@ obj-$(CONFIG_XEN_BALLOON)	+= balloon.
>   obj-$(CONFIG_XEN_DEV_EVTCHN)	+= evtchn.o
>   obj-$(CONFIG_XENFS)		+= xenfs/
>   obj-$(CONFIG_XEN_SYS_HYPERVISOR)	+= sys-hypervisor.o
>  +obj-$(CONFIG_SWIOTLB_XEN)	+= swiotlb-xen.o
> + obj-$(CONFIG_XEN_PLATFORM_PCI)	+= platform-pci.o
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel
