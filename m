Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814Ab0DNVDj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 17:03:39 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:59877 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756194Ab0DNVDi (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 14 Apr 2010 17:03:38 -0400
Date: Wed, 14 Apr 2010 17:01:43 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Chris Wright <chrisw@sous-sol.org>, USB list <linux-usb@vger.kernel.org>,
       Greg KH <gregkh@suse.de>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       iommu@lists.linux-foundation.org, Andi Kleen <andi@firstfloor.org>,
       Daniel Mack <daniel@caiaq.de>, Pedro Ribeiro <pedrib@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: USB transfer_buffer allocations on 64bit systems
Message-ID: <20100414210143.GB5753@phenom.dumpdata.com>
References: <20100414183826.GA25962@sequoia.sous-sol.org> <Pine.LNX.4.44L0.1004141622410.1716-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1004141622410.1716-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4BC62D7A.01AA:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 14, 2010 at 04:29:22PM -0400, Alan Stern wrote:
> On Wed, 14 Apr 2010, Chris Wright wrote:
> 
> > So dma_map_single is the case that's failing, but you think the mask is
> > correct?  What about the direction?
> 
> The mask and direction are unquestionably correct.  The mask is set up 
> by pci_setup_device() and not changed thereafter.  Furthermore, the 
> audio works okay until another device (a DVB tuner) is plugged in.  

Could the driver for the DVB tuner change the PCI mask? That is, change
the pci mask way after it has been initialized (don't laugh, this did
happend - as I remember 4 months fix was posted on the DRM mailing list
for this).
