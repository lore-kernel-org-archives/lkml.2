Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab1KAO05 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 10:26:57 -0400
Received: from tex.lwn.net ([70.33.254.29]:41383 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754357Ab1KAO0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 10:26:55 -0400
Date: Tue, 1 Nov 2011 08:26:53 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: loody <miloody@gmail.com>
Cc: kernelnewbies@kernelnewbies.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: some questions about block and scatterlist
Message-ID: <20111101082653.4fa844e4@bike.lwn.net>
In-Reply-To: <CANudz+unARaENw50p2iL_Ur1YQj0f=9Ndev0OyZ=790xDjbTCw@mail.gmail.com>
References: <CANudz+unARaENw50p2iL_Ur1YQj0f=9Ndev0OyZ=790xDjbTCw@mail.gmail.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Nov 2011 19:32:38 +0900
loody <miloody@gmail.com> wrote:

> My questions are below:

As are some answers :)

> 1. Are all struct page 32-bit aligned?

Certainly, I would expect any structures found in the system memory map to
be so aligned, yes.  If you've created an arbitrary one elsewhere I'm only
99% sure it would be.

> If so, where is this part of code for handleing struct page be 32-bits aligned?

Note that the size of struct page is carefully considered, and that they
are packed as densely as possible, both externally and internally.  No
lesser alignment would make sense.

> 2. if the page of scatterlist is located at high mem, how does
> dma_map_sg mapping the virtual address?

That depends on a vast array of things.  What are the addressing
capabilities of the target device?  Is there an IOMMU involved?

> 3. in blk_rq_map_sg, it seems we only copy bvec->bv_page to sg->page_link
>    why don't we add dma_address in bvec and send the bio directly to
> the lower level driver?

That would be a bit of a mixing of the layers, if nothing else.

> 4. if I plug a USB HD with 3 partitions, will there be 3 request_queues?

No, there is one request queue for the underlying device.

That's an interesting mix of questions.  If you have more in the future,
you'll likely get more (and more clueful) responses if they're accompanied
by the code you're working on.

Thanks,

jon
