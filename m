Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276Ab0CYXCF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 19:02:05 -0400
Received: from smtp127.mail.ukl.yahoo.com ([77.238.184.58]:28283 "HELO
	smtp127.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750901Ab0CYXCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 19:02:01 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.es;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=C1QIB09+8vONgoJSbtIyxKGxnmXHAzGvCdpkOX3F8mlR7Mtp+jD0T8VudtaFwPccpiizuZ54WvNHRnc4wcd0ciq/gn4/wYvCrCi3R5ku3Q78Gtfzyf//rvOKbKCebsbbSSL+v85+Hdyb60ZqUeiac9xlXQrCnsgHPFaTnG6KOfg=  ;
X-Yahoo-SMTP: czee06uswBAtfIYshc.kP27UlfEXaxwWNSjJ
X-YMail-OSG: T7Jjh_8VM1mh1pOaUbHWLC12mfFR1xFo0uzvWIBuC2gTyyKNvkL64qLw2EcRSACg5qlKA7t43m1WhsN7plROqkh.mLr.hpAh410M_owavsy5NKsvJyWogOK0Nk9hZvUu2HpagGDXajeQw9EEto6DaKw5G9Gu5SYHLGbkvjS2t7JXFhUTy8TkHsigGtYIYx1yu33F5Z2vH2.FJsmH5mzbzKuRxbXx0f9.NZnOgJ29DW_r6z6T51onJPMgxVulQOkvu.zbqWVU93R9.rHrA5o_gIVASByJs58A
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4BABEB62.200@yahoo.es>
Date: Fri, 26 Mar 2010 00:01:54 +0100
From: Albert Herranz <albert_herranz@yahoo.es>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, chrisw@sous-sol.org,
       Ian.Campbell@eu.citrix.com, jeremy@goop.org, dwmw2@infradead.org,
       alex.williamson@hp.com, stern@rowland.harvard.edu
Subject: Re: [PATCH] swiotlb v0.6: seperation of physical/virtual address
 translation
References: <1269011062-25915-1-git-send-email-konrad.wilk@oracle.com> <20100325135610.GA10991@phenom.dumpdata.com>
In-Reply-To: <20100325135610.GA10991@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad Rzeszutek Wilk wrote:
> To my happy surprise, I've found that Mr. Sander Eikelenboom and Mr. Albert Herranz
> had been using these patches.
> 
> I've asked whether Mr. Sander wouldn't mind chiming in and he said he
> would gladly add 'Tested-by:  Sander Eikelenboom <linux@eikelenboom.it>'
> to the patches. I haven't asked Mr. Albert since he is busy making his
> set of patches for the Wii controller ready.
> 

Actually, I'm waiting now for some USB core changes to settle down before sending again a patch series.
Alan Stern and I were touching the same USB code base, so it makes sense to coordinate our efforts.

> Mr. Sander's long summary (a bit of explanation here: these five patches form the
> basis of a branch that has Xen PCI frontend driver allowing PCI
> passthrough, so his testing encompassed these five and many more):
> 
> "If have placed the usb controller in another system now.
> 
> So it's tested with:
> 
> Intel system, usb 3.0 xhci PCIe host controller:
> - Xen-4.0.0rc6, dom0 xen-next, domU your 2.6.33 tree i mentioned
> - Baremetal on this system with the  2.6.33 from your tree
> 
> AMD system (running now, no iommu in this system): passthrough of USB2.0
> PCI host controller, USB2.0 PCIe hostcontroller, USB 3.0
> +PCIe host controller, 1 usb videograbber per usb controller.
> - Xen-4.0.0rc6, dom0 2.6.31.12 pvops kernel from jeremy's tree, domU
>   your 2.6.33 tree i mentioned
> 
> 
> All(with xen and baremetal) have been tested by grabbing raw or mpeg2
> video streams to v4l usb capture devices.
> 
> So a 'Tested-by' seems to be justified i would say"
> 
> The git branch in question is pv/merge.2.6.33 from GIT tree:
> git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git
> 

What I've tested (successfully) so far are these patches from your master branch in the tree:
git://git.kernel.org/pub/scm/linux/kernel/git/konrad/swiotlb-2.6.git

 swiotlb: EXPORT_SYMBOL_GPL functions + variables that are defined in the header file.
 swiotlb: Make swiotlb bookkeeping functions visible in the header file.
 swiotlb: Make all bookkeeping functions and variables have same prefix.
 swiotlb: swiotlb_bk_map_single: abstract out swiotlb_virt_to_bus calls out.
 swiotlb: Make internal bookkeeping functions have 'swiotlb_bk' prefix.

And these two add-ons (which I needed for supporting swiotlb on the Wii):

 swiotlb: make swiotlb_bounce() __weak
 swiotbl: add back swiotlb_alloc_boot()

The swiotlb bk code has been tested as part of the "MEM2" DMA ops code used to support the EHCI controller of the Wii.
That support code includes (as of last patch series) the following patches too:

 wii: hollywood ehci controller support
 wii: enable swiotlb
 wii: add mem2 dma mapping ops
 wii: have generic dma coherent
 USB: add HCD_NO_COHERENT_MEM host controller driver flag
 USB: refactor unmap_urb_for_dma/map_urb_for_dma
 powerpc: add min_direct_dma_addr
 powerpc: add per-device dma coherent support

The last iteration of the series (v5) is available at:
http://marc.info/?l=linux-usb&m=126902357306668

Concerns raised so far for v5 will be addressed in v6.

Thanks,
Albert

