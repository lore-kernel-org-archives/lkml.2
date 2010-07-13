Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067Ab0GMGAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 02:00:53 -0400
Received: from sh.osrg.net ([192.16.179.4]:55858 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032Ab0GMGAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 02:00:51 -0400
Date: Tue, 13 Jul 2010 14:59:08 +0900
To: zpfeffer@codeaurora.org
Cc: joro@8bytes.org, dwalker@codeaurora.org, andi@firstfloor.org,
        randy.dunlap@oracle.com, mel@csn.ul.ie, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 3/3] mm: iommu: The Virtual Contiguous Memory Manager
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4C3BFDD3.8040209@codeaurora.org>
References: <4C2D965F.5000206@codeaurora.org>
	<20100710145639.GC10080@8bytes.org>
	<4C3BFDD3.8040209@codeaurora.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100713145852C.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 13 Jul 2010 14:59:10 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Jul 2010 22:46:59 -0700
Zach Pfeffer <zpfeffer@codeaurora.org> wrote:

> Joerg Roedel wrote:
> > On Fri, Jul 02, 2010 at 12:33:51AM -0700, Zach Pfeffer wrote:
> >> Daniel Walker wrote:
> > 
> >>> So if we include this code which "map implementations" could you
> >>> collapse into this implementations ? Generally , what currently existing
> >>> code can VCMM help to eliminate?
> >> In theory, it can eliminate all code the interoperates between IOMMU,
> >> CPU and non-IOMMU based devices and all the mapping code, alignment,
> >> mapping attribute and special block size support that's been
> >> implemented.
> > 
> > Thats a very abstract statement. Can you point to particular code files
> > and give a rough sketch how it could be improved using VCMM?
> 
> I can. Not to single out a particular subsystem, but the video4linux
> code contains interoperation code to abstract the difference between
> sg buffers, vmalloc buffers and physically contiguous buffers. The
> VCMM is an attempt to provide a framework where these and all the
> other buffer types can be unified.

Why video4linux can't use the DMA API? Doing DMA with vmalloc'ed
buffers is a thing that we should avoid (there are some exceptions
like xfs though).
