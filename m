Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab2ADP7a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 10:59:30 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:44025 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755918Ab2ADP72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 10:59:28 -0500
Message-ID: <1325692766.2758.22.camel@dabdike.int.hansenpartnership.com>
Subject: Re: =?UTF-8?Q?=E3=80=90Question=E3=80=91Whether?= it's legal to
 enable same physical DMA memory mapped for different NIC device?
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Yanfei Wang <backyes@mail.ustc.edu.cn>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, linux-pci@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 04 Jan 2012 09:59:26 -0600
In-Reply-To: <CAJULongKix3QXmcoUcraQxCyLN0wz6oe6p5Efg2A7S_r3nO6Fg@mail.gmail.com>
References: <CAJULonj9rFDKNCzpEXj2r3XjkYojy-CGYpVQ1RF8SxwLVrXqAA@mail.gmail.com>
	 <20120103203357.GD17472@phenom.dumpdata.com>
	 <CAJULongKix3QXmcoUcraQxCyLN0wz6oe6p5Efg2A7S_r3nO6Fg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-04 at 10:44 +0800, Yanfei Wang wrote:
> On Wed, Jan 4, 2012 at 4:33 AM, Konrad Rzeszutek Wilk
> <konrad.wilk@oracle.com> wrote:
> > On Wed, Dec 07, 2011 at 10:16:40PM +0800, ustc.mail wrote:
> >> Dear all,
> >>
> >> In NIC driver, to eliminate the  overhead of dma_map_single() for DMA
> >> packet data,  we have statically allocated huge DMA memory buffer ring
> >> at once instead of calling dma_map_single() per packet.  Considering
> >> to further reduce the copy overhead between different NIC(port) ring
> >> while forwarding, one packet from a input NIC(port) will be
> >> transferred to output NIC(port) with no any copy action.
> >>
> >> To satisfy this requirement, the packet memory should be mapped into
> >> input port and unmapped when leaving input port, then mapped into
> >> output port and unmapped later.
> >>
> >> Whether it's legal to map the same DMA memory into input and output
> >> port simultaneously? If it's not, then the zero-copy for packet
> >> forwarding is not feasible?
> >>
> >
> > Did you ever a get a response about this?
> No.

This is probably because no-one really understands what you're asking.
As far as mapping memory to PCI devices goes, it's the job of the bridge
(or the iommu which may or may not be part of the bridge).  A standard
iommu tends not to care about devices and functions, so a range once
mapped is available to everything behind the bridge.  A more secure
virtualisation based iommu (like the on in VT-D) does, and tends to map
ranges per device.  I know of none that map per device and function, but
maybe there are.

Your question reads like you have a range of memory mapped to a PCI
device that you want to use for two different purposes, can you do this?
to which the answer is that a standard PCI bridge really doesn't care
and it all depends on the mechanics of the actual device.  The only
wrinkle might be if the two different purposes are on two separate PCI
functions of the device and the iommu does care.

> >
> > Is the output/input port on a seperate device function? Or is it
> > just a specific MMIO BAR in your PCI device?
> >
> Platform: x86, intel nehalem 8Core NUMA, linux 2.6.39, 10G
> 82599NIC(two ports per NIC card);
> Function: Forwarding packets between different ports.
> Targets: Forwarding packets with Zero-Overhead, despite other obstacles.

This still doesn't really provide the information needed to elucidate
the question.

James


