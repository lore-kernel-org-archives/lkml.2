Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987Ab0CYN6j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 09:58:39 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:61173 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773Ab0CYN6h (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 25 Mar 2010 09:58:37 -0400
Date: Thu, 25 Mar 2010 09:56:10 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, albert_herranz@yahoo.es
Cc: chrisw@sous-sol.org, Ian.Campbell@eu.citrix.com, jeremy@goop.org,
       dwmw2@infradead.org, alex.williamson@hp.com
Subject: Re: [PATCH] swiotlb v0.6: seperation of physical/virtual address
	translation
Message-ID: <20100325135610.GA10991@phenom.dumpdata.com>
References: <1269011062-25915-1-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269011062-25915-1-git-send-email-konrad.wilk@oracle.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4BAB6BBD.0108:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 19, 2010 at 11:04:17AM -0400, Konrad Rzeszutek Wilk wrote:
> Fujita-san et al.
> 
> Attached is a set of patches that separate the address translation
> (virt_to_phys, virt_to_bus, etc) from the SWIOTLB library.
> 
> Since the last posting I've:
>  - Made the exported functions/variables have the 'swiotlb_bk' prefix instead
>    of the 'do_[map|unmap]*' and 'io_tlb_*' combination.
>  - dropped the checkpatches/other reworks patches.
   - and testing, which warrants:
Tested-by:  Sander Eikelenboom <linux@eikelenboom.it>

To my happy surprise, I've found that Mr. Sander Eikelenboom and Mr. Albert Herranz
had been using these patches.

I've asked whether Mr. Sander wouldn't mind chiming in and he said he
would gladly add 'Tested-by:  Sander Eikelenboom <linux@eikelenboom.it>'
to the patches. I haven't asked Mr. Albert since he is busy making his
set of patches for the Wii controller ready.

Mr. Sander's long summary (a bit of explanation here: these five patches form the
basis of a branch that has Xen PCI frontend driver allowing PCI
passthrough, so his testing encompassed these five and many more):

"If have placed the usb controller in another system now.

So it's tested with:

Intel system, usb 3.0 xhci PCIe host controller:
- Xen-4.0.0rc6, dom0 xen-next, domU your 2.6.33 tree i mentioned
- Baremetal on this system with the  2.6.33 from your tree

AMD system (running now, no iommu in this system): passthrough of USB2.0
PCI host controller, USB2.0 PCIe hostcontroller, USB 3.0
+PCIe host controller, 1 usb videograbber per usb controller.
- Xen-4.0.0rc6, dom0 2.6.31.12 pvops kernel from jeremy's tree, domU
  your 2.6.33 tree i mentioned


All(with xen and baremetal) have been tested by grabbing raw or mpeg2
video streams to v4l usb capture devices.

So a 'Tested-by' seems to be justified i would say"

The git branch in question is pv/merge.2.6.33 from GIT tree:
git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git

