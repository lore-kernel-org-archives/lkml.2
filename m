Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757945Ab0CaBlA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 21:41:00 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38111 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756257Ab0CaBk6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 21:40:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Z2wL32IADoiJddfgETKB5DTDMHBVeTCB4k5wXK4Seq8Kgp4t3W6EdGEjjgJpEp4Hbu
         fcq8bbDp12CZpB+XlwNUoBLMH+THiEZSwDhyM+ggm4ELkyYW1DFi7iXilZwbbTBbwrK2
         mqtIE5E+wE7qpQNmhoQUtMfErH/1r94aYvGH4=
MIME-Version: 1.0
In-Reply-To: <20100331010744.GK31126@trinity.fluff.org>
References: <4BAAD5BB.7050101@samsung.com>
	 <1b68c6791003251908w299806cbm1443728ea08cfb72@mail.gmail.com>
	 <20100331010744.GK31126@trinity.fluff.org>
Date: Wed, 31 Mar 2010 10:40:57 +0900
Message-ID: <t2r1b68c6791003301840n8b3f94b7xdbf8ddc1fe0165ff@mail.gmail.com>
Subject: Re: [PATCH v2] PL330: Add PL330 DMA controller driver
From: jassi brar <jassisinghbrar@gmail.com>
To: Ben Dooks <ben-linux@fluff.org>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>, linus.ml.walleij@gmail.com,
       dan.j.williams@intel.com, kyungmin.park@samsung.com,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 10:07 AM, Ben Dooks <ben-linux@fluff.org> wrote:
> On Fri, Mar 26, 2010 at 11:08:06AM +0900, jassi brar wrote:
>> On Thu, Mar 25, 2010 at 12:17 PM, Joonyoung Shim
>> <jy0922.shim@samsung.com> wrote:
>> > +static struct pl330_desc *
>> > +pl330_alloc_descriptor(struct pl330_chan *pl330_ch, gfp_t flags)
>> > +{
>> > +       struct device *dev = pl330_ch->pl330_dev->common.dev;
>> > +       struct pl330_desc *desc;
>> > +       dma_addr_t phys;
>> > +
>> > +       desc = kzalloc(sizeof(*desc), flags);
>> > +       if (!desc)
>> > +               return NULL;
>> > +
>> > +       desc->desc_pool_virt = dma_alloc_coherent(dev, PL330_POOL_SIZE, &phys,
>> > +                       flags);
>> These allocations are inefficient and don't need to be done so often.
>> My implementation allocates a pool of such buffers(size specified by
>> DMA API driver)
>> and manage them by simple pointer manipulation.
>> Though the xfer requests for DMA API has to be managed in the DMA API driver.
>
> There's a dma pool implementation too in the kernel.
I meant during 'probe' of the DMAC a chunk of dma consistent memory is allocated
for MicroCode for each channel.
We use the same chunk during xfers, since we can generate MC in a way that 256
bytes are enough to do xfer of 2.5MB at burst size of 1 byte and for
bulkier requests
the DMA API driver can either break the bigger request or allocate
bigger chunk for
the channels.
