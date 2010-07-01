Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625Ab0GAP3W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 11:29:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20361 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753916Ab0GAP3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 11:29:21 -0400
Subject: Re: [PATCH V2] VFIO driver: Non-privileged user level PCI drivers
From: Alex Williamson <alex.williamson@redhat.com>
To: Tom Lyon <pugs@cisco.com>
Cc: randy.dunlap@oracle.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       chrisw@sous-sol.org, joro@8bytes.org, hjk@linutronix.de, mst@redhat.com,
       avi@redhat.com, gregkh@suse.de, aafabbri@cisco.com, scofeldm@cisco.com,
       Donald Dutile <ddutile@redhat.com>
In-Reply-To: <4c0eb470.1HMjondO00NIvFM6%pugs@cisco.com>
References: <4c0eb470.1HMjondO00NIvFM6%pugs@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Jul 2010 09:29:04 -0600
Message-ID: <1277998144.10112.58.camel@x201>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-08 at 14:21 -0700, Tom Lyon wrote:
> +The VFIO_DMA_MASK ioctl is used to set the maximum permissible DMA address
> +(device dependent). It takes a single unsigned 64 bit integer as an argument.
> +This call also has the side effect of enabling PCI bus mastership.

Hi Tom,

This interface doesn't make sense for the MAP_IOVA user.  Especially in
qemu, we have no idea what the DMA mask is for the device we're
assigning.  It doesn't really matter though because the guest will use
bounce buffers internally once it loads the device specific drivers and
discovers the DMA mask.  This only seems relevant if we're using a
DMA_MAP call that gets to pick the dmaaddr, so I'd propose we only make
this a required call for that interface, and create a separate ioctl for
actually enabling bus master.  Thanks,

Alex

