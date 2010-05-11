Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167Ab0EKB5p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 21:57:45 -0400
Received: from sh.osrg.net ([192.16.179.4]:46184 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758093Ab0EKB5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 21:57:39 -0400
Date: Tue, 11 May 2010 10:56:30 +0900
To: konrad.wilk@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp, chrisw@sous-sol.org, jeremy@goop.org,
       albert_herranz@yahoo.es, linux-kernel@vger.kernel.org,
       Ian.Campbell@eu.citrix.com, linux@eikelenboom.it,
       iommu@lists.linux-foundation.org, dwmw2@infradead.org,
       alex.williamson@hp.com
Subject: Re: [PATCH 2/6] swiotlb: swiotlb_tbl_map_single: abstract out
	swiotlb_virt_to_bus calls out.
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100510193118.GA5906@phenom.dumpdata.com>
References: <1270672170-31833-3-git-send-email-konrad.wilk@oracle.com>
	<20100509223623X.fujita.tomonori@lab.ntt.co.jp>
	<20100510193118.GA5906@phenom.dumpdata.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100511105527Z.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 11 May 2010 10:56:34 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 May 2010 15:31:18 -0400
Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:

> On Sun, May 09, 2010 at 10:41:15PM +0900, FUJITA Tomonori wrote:
> > On Wed,  7 Apr 2010 16:29:26 -0400
> > Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> > 
> > > We want to move that function out of swiotlb_tbl_map_single so that the caller
> > > of this function does the virt->phys->bus address translation.
> > > 
> > > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > > ---
> > >  lib/swiotlb.c |   22 ++++++++++++++--------
> > >  1 files changed, 14 insertions(+), 8 deletions(-)
> > 
> > It would be better to do something like that instead of spreading
> > swiotlb_virt_to_bus()?
> 
> Yes! Thought I am confused by the name. In the past you mentioned 'tbl',
> but here it is 'tlb'. I presume 'tbl' is the right one?

Oops, yeah. I meant 'tbl' for 'table' since Calgary and POWERPC IOMMUs
use 'iommu_table' struct to store the global info.

Please replace 'tlb' with 'tbl'.
