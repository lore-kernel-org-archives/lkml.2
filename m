Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055Ab0FGFAF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 01:00:05 -0400
Received: from sh.osrg.net ([192.16.179.4]:36916 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292Ab0FGFAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 01:00:03 -0400
Date: Mon, 7 Jun 2010 13:59:48 +0900
To: mitov@issp.bas.bg
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org
Subject: Re: [BUG][PATCH]dma-coherent.c: error path bug
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <201006070743.20226.mitov@issp.bas.bg>
References: <201006070708.57453.mitov@issp.bas.bg>
	<20100607132631W.fujita.tomonori@lab.ntt.co.jp>
	<201006070743.20226.mitov@issp.bas.bg>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100607135845B.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 07 Jun 2010 13:59:48 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jun 2010 07:43:19 +0300
Marin Mitov <mitov@issp.bas.bg> wrote:

> On Monday, June 07, 2010 07:27:49 am FUJITA Tomonori wrote:
> > On Mon, 7 Jun 2010 07:08:56 +0300
> > Marin Mitov <mitov@issp.bas.bg> wrote:
> > 
> > > On Monday, June 07, 2010 05:30:48 am FUJITA Tomonori wrote:
> > > > On Sun, 6 Jun 2010 13:53:04 +0300
> > > > Marin Mitov <mitov@issp.bas.bg> wrote:
> > > > 
> > > > > Hi all,
> > > > > 
> > > > > The error path in dma_declare_coherent_memory() leaves 
> > > > > the pointer dev->dma_mem non completely initialized.
> > > > > 
> > > > > If allocation of dev->dma_mem succeeds, 
> > > > > but allocation of dev->dma_mem->bitmap fails
> > > > > dev->dma_mem is freed, but left non NULL
> > > > > and non completely initialized.
> > > > > 
> > > > > Either zero it after being freed (one liner patch), or assign to 
> > > > > dev->dma_mem only completely initialized structure (patch included).
> > > > > 
> > > > > Comments welcome.
> > > > > 
> > > > > Marin Mitov
> > > > > 
> > > > > Signed-off-by: Marin Mitov <mitov@issp.bas.bg>
> > > > 
> > > > Hmm, if dma_declare_coherent_memory() fails, the driver doesn't use
> > > > dev->dma_mem. So even if dev->dma_mem points to a freed memory, I'm
> > > > not sure that it causes a real problem. We could call this patch a
> > > > cleanup though.
> > > > 
> > > My understanding of dma_alloc_coherent() is that  we first try to allocate from 
> > > per-device coherent memory and we do it using dma_alloc_from_coherent()
> > > (in drivers/base/dma-coherent.c) if dev->dma_mem is not NULL (and we have 
> > > left it not NULL, here is the problem). If allocation of dev->dma_mem->bitmap 
> > > fails dev->dma_mem must be NULL.
> > 
> > But are there any driver that can continue when dma_declare_coherent_memory() fails?
> > 
> I do not know if such a real driver exists.

>From a quick look, seems no. There is no fallback for such hardware,
it's safe assumption, I guess.

As I wrote, I don't think that the patch is rc material since seems
that this doesn't cause a real problem.  However, it looks fine for
the next merge window.

Thanks,
