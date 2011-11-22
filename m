Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab1KVR1a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 12:27:30 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:35428 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab1KVR12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 12:27:28 -0500
Date: Tue, 22 Nov 2011 10:27:25 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Jean-Francois Dagenais <jeff.dagenais@gmail.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg KH <gregkh@suse.de>, tglx@linutronix.de,
        linux-pci@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
Subject: Re: extra large DMA buffer for PCI-E device under UIO
Message-ID: <20111122172725.GK4387@parisc-linux.org>
References: <B458B2F0-2DDA-461F-A125-8C6C4CDEB6C5@gmail.com> <20111118220849.GA25205@suse.de> <9E9C8A95-723C-427A-AD01-17284EDF7E4F@gmail.com> <20111121173620.GA5028@suse.de> <20111121181724.GB12011@local> <4498E0C9-B5E9-44B5-8868-140D6416100E@gmail.com> <20111122153525.GB17268@redhat.com> <40906F5E-5E97-44CF-AB95-40355204B63F@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40906F5E-5E97-44CF-AB95-40355204B63F@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 11:54:22AM -0500, Jean-Francois Dagenais wrote:
> That is quite interesting. It really seems like my VT-d recipe to create 128MB for my PCI-e
> FPGA to write into is covered by this patch.
> 
> My problem is that our FPGA is connected to one of the atom E6XX's PCI-e links, so no
> iommu :( Since our first product had VT-d, the FPGA, uio based module and userspace
> code is designed such that the device sees a huge contiguous memory chunk. This is key
> to the performance of the FPGA, which is essentially decoupled from the CPU for it's real-time
> acquisition.

Is it really key?  If you supported, ohidon'tknow, 2MB pages, you'd
need 64 entries in the FPGA to store the addresses of those 2MB pages,
which doesn't sound like a huge burden.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
