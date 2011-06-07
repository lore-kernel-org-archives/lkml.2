Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761Ab1FGL0j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 07:26:39 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:42945 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913Ab1FGL0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 07:26:38 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Ohad Ben-Cohen" <ohad@wizery.com>
Subject: Re: [RFC 2/6] omap: iovmm: generic iommu api migration
Date: Tue, 7 Jun 2011 13:26:52 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37-gentoo-r3; KDE/4.6.2; x86_64; ; )
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Hiroshi.DOYU@nokia.com, arnd@arndb.de, davidb@codeaurora.org,
        Joerg.Roedel@amd.com
References: <1307053663-24572-1-git-send-email-ohad@wizery.com> <201106071105.16262.laurent.pinchart@ideasonboard.com> <BANLkTi=nJXSEfWRXqwnHys1b5i5rgLcYpw@mail.gmail.com>
In-Reply-To: <BANLkTi=nJXSEfWRXqwnHys1b5i5rgLcYpw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106071326.53106.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

On Tuesday 07 June 2011 12:28:53 Ohad Ben-Cohen wrote:
> On Tue, Jun 7, 2011 at 12:05 PM, Laurent Pinchart wrote:
> > pgsz isn't used anymore, you can remove it.
> 
> Ok.
> 
> >> +             order = get_order(bytes);
> > 
> > Does iommu_map() handle offsets correctly, or does it expect pa to be
> > aligned to an order (or other) boundary ?
> 
> Right now we have a BUG_ON if pa is unaligned, but that can be changed
> if needed (do we want it to handle offsets ?).

At least for the OMAP3 ISP we need to, as video buffers don't necessarily 
start on page boundaries.

> > As Russell pointed out, we should use sg->length instead of
> > sg_dma_length(sg). sg_dma_length(sg) is only valid after the scatter
> > list has been DMA-mapped, which doesn't happen in the iovmm driver. This
> > applies to all sg_dma_len(sg) calls.
> 
> I'll make sure I don't introduce such calls, but it sounds like a
> separate patch should take care of the existing ones; pls tell me if
> you want me to send one.

A separate patch is indeed needed, yes. As you're already working on iommu it 
might be simpler if you add it to your tree. Otherwise I can send it.

-- 
Regards,

Laurent Pinchart
