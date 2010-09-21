Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740Ab0IUVnp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 17:43:45 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:53485 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158Ab0IUVno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 17:43:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=KOUKFVGu/Ip07+E463UI2zFTLn3Fm0tw+buc2tRCeJ9suJbY9ew+cpcdiJuVyj3B64
         N3hknO1DgPyGtzZcSsdOniEtYH0wI8WG4N90ZSS4Nhd5fiAWlpUgi7vD5P1JsDgT5fmC
         1ALhXCuLJZs5Wcs7xu1tVS/FtTuNN+YQMBrC8=
MIME-Version: 1.0
In-Reply-To: <20100921163456.7e2c9b32@udp111988uds.am.freescale.net>
References: <1285066638-7473-1-git-send-email-leoli@freescale.com>
 <877FD0B5-19A7-4A16-831E-369B80B104EA@kernel.crashing.org>
 <AANLkTimiwtoa6i10OTcgFnvbvcO9N4KWHyt4Poj-yj=T@mail.gmail.com> <20100921163456.7e2c9b32@udp111988uds.am.freescale.net>
From: Timur Tabi <timur.tabi@gmail.com>
Date: Tue, 21 Sep 2010 16:43:12 -0500
Message-ID: <AANLkTine--kry0c0n87WOqYyi3AQOb2KnmNRs-MeXcQt@mail.gmail.com>
Subject: Re: [PATCH] fsldma: add support to 36-bit physical address
To: Scott Wood <scottwood@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>, dan.j.williams@intel.com,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 21, 2010 at 4:34 PM, Scott Wood <scottwood@freescale.com> wrote:

> This doesn't control allocation (it probably should with
> dma_alloc_coherent, though I don't see it in the code), it controls
> whether swiotlb will create a bounce buffer -- defeating the point of
> using DMA to accelerate a memcpy.

But it would do that only for the 'dev' used in the dma_set_mask()
call.  That dev is only used here:

	chan->desc_pool = dma_pool_create("fsl_dma_engine_desc_pool",
					  chan->dev,
					  sizeof(struct fsl_desc_sw),
					  __alignof__(struct fsl_desc_sw), 0);

Since we don't DMA the descriptors themselves, I just don't see how
this patch does anything.

-- 
Timur Tabi
Linux kernel developer at Freescale
