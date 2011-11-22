Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758238Ab1KVRin (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 12:38:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17929 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754135Ab1KVRil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 12:38:41 -0500
Date: Tue, 22 Nov 2011 19:40:02 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Jean-Francois Dagenais <jeff.dagenais@gmail.com>,
        "Hans J. Koch" <hjk@hansjkoch.de>, Greg KH <gregkh@suse.de>,
        tglx@linutronix.de, linux-pci@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: extra large DMA buffer for PCI-E device under UIO
Message-ID: <20111122174001.GB29068@redhat.com>
References: <B458B2F0-2DDA-461F-A125-8C6C4CDEB6C5@gmail.com>
 <20111118220849.GA25205@suse.de>
 <9E9C8A95-723C-427A-AD01-17284EDF7E4F@gmail.com>
 <20111121173620.GA5028@suse.de>
 <20111121181724.GB12011@local>
 <4498E0C9-B5E9-44B5-8868-140D6416100E@gmail.com>
 <20111122153525.GB17268@redhat.com>
 <40906F5E-5E97-44CF-AB95-40355204B63F@gmail.com>
 <20111122172725.GK4387@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111122172725.GK4387@parisc-linux.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 10:27:25AM -0700, Matthew Wilcox wrote:
> On Tue, Nov 22, 2011 at 11:54:22AM -0500, Jean-Francois Dagenais wrote:
> > That is quite interesting. It really seems like my VT-d recipe to create 128MB for my PCI-e
> > FPGA to write into is covered by this patch.
> > 
> > My problem is that our FPGA is connected to one of the atom E6XX's PCI-e links, so no
> > iommu :( Since our first product had VT-d, the FPGA, uio based module and userspace
> > code is designed such that the device sees a huge contiguous memory chunk. This is key
> > to the performance of the FPGA, which is essentially decoupled from the CPU for it's real-time
> > acquisition.
> 
> Is it really key?  If you supported, ohidon'tknow, 2MB pages, you'd
> need 64 entries in the FPGA to store the addresses of those 2MB pages,
> which doesn't sound like a huge burden.

Ah yes, we have this support for on-device IOMMUs. Maybe a generic
access driver will work if you implement an IOMMU in FPGA.
You would need to separate the programming of the IOMMU
from the rest of the functionality of the device,
protecting it from a malicious driver, somehow.

> -- 
> Matthew Wilcox				Intel Open Source Technology Centre
> "Bill, look, we understand that you're interested in selling us this
> operating system, but compare it to ours.  We can't possibly take such
> a retrograde step."
