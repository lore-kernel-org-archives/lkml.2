Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736Ab0FGEpy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 00:45:54 -0400
Received: from mail.issp.bas.bg ([195.96.236.10]:45296 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781Ab0FGEpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 00:45:53 -0400
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [BUG][PATCH]dma-coherent.c: error path bug
Date: Mon, 7 Jun 2010 07:43:19 +0300
User-Agent: KMail/1.13.3 (Linux/2.6.34-rc7; KDE/4.4.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <201006061353.05310.mitov@issp.bas.bg> <201006070708.57453.mitov@issp.bas.bg> <20100607132631W.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100607132631W.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006070743.20226.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 07, 2010 07:27:49 am FUJITA Tomonori wrote:
> On Mon, 7 Jun 2010 07:08:56 +0300
> Marin Mitov <mitov@issp.bas.bg> wrote:
> 
> > On Monday, June 07, 2010 05:30:48 am FUJITA Tomonori wrote:
> > > On Sun, 6 Jun 2010 13:53:04 +0300
> > > Marin Mitov <mitov@issp.bas.bg> wrote:
> > > 
> > > > Hi all,
> > > > 
> > > > The error path in dma_declare_coherent_memory() leaves 
> > > > the pointer dev->dma_mem non completely initialized.
> > > > 
> > > > If allocation of dev->dma_mem succeeds, 
> > > > but allocation of dev->dma_mem->bitmap fails
> > > > dev->dma_mem is freed, but left non NULL
> > > > and non completely initialized.
> > > > 
> > > > Either zero it after being freed (one liner patch), or assign to 
> > > > dev->dma_mem only completely initialized structure (patch included).
> > > > 
> > > > Comments welcome.
> > > > 
> > > > Marin Mitov
> > > > 
> > > > Signed-off-by: Marin Mitov <mitov@issp.bas.bg>
> > > 
> > > Hmm, if dma_declare_coherent_memory() fails, the driver doesn't use
> > > dev->dma_mem. So even if dev->dma_mem points to a freed memory, I'm
> > > not sure that it causes a real problem. We could call this patch a
> > > cleanup though.
> > > 
> > My understanding of dma_alloc_coherent() is that  we first try to allocate from 
> > per-device coherent memory and we do it using dma_alloc_from_coherent()
> > (in drivers/base/dma-coherent.c) if dev->dma_mem is not NULL (and we have 
> > left it not NULL, here is the problem). If allocation of dev->dma_mem->bitmap 
> > fails dev->dma_mem must be NULL.
> 
> But are there any driver that can continue when dma_declare_coherent_memory() fails?
> 
I do not know if such a real driver exists.

My understanding of drivers' use of dma_declare_coherent_memory() is to
declare some (may be on board) memory as coherent, so when they call 
dma_alloc_coherent() the request is satisfied first from this area and when 
it is exhausted fall back to other pools of coherent memory. As far as a fall back
exists the driver may continue even if dma_declare_coherent_memory() fails.

Marin Mitov
