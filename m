Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609Ab2JWC3q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 22:29:46 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:51822 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756507Ab2JWC3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 22:29:44 -0400
MIME-Version: 1.0
In-Reply-To: <0000013a88e2e9dc-9f72abd3-9a31-454c-b70b-9937ba54c0ee-000000@email.amazonses.com>
References: <1350748093-7868-1-git-send-email-js1304@gmail.com>
	<1350748093-7868-2-git-send-email-js1304@gmail.com>
	<0000013a88e2e9dc-9f72abd3-9a31-454c-b70b-9937ba54c0ee-000000@email.amazonses.com>
Date: Tue, 23 Oct 2012 11:29:44 +0900
Message-ID: <CAAmzW4Nz_=_Tj-D=DXaO-SR5pRZ_n7-gfVbKHa+=DP0NQioAaQ@mail.gmail.com>
Subject: Re: [PATCH for-v3.7 2/2] slub: optimize kmalloc* inlining for GFP_DMA
From: JoonSoo Kim <js1304@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/22 Christoph Lameter <cl@linux.com>:
> On Sun, 21 Oct 2012, Joonsoo Kim wrote:
>
>> kmalloc() and kmalloc_node() of the SLUB isn't inlined when @flags = __GFP_DMA.
>> This patch optimize this case,
>> so when @flags = __GFP_DMA, it will be inlined into generic code.
>
> __GFP_DMA is a rarely used flag for kmalloc allocators and so far it was
> not considered that it is worth to directly support it in the inlining
> code.
>
>

Hmm... but, the SLAB already did that optimization for __GFP_DMA.
Almost every kmalloc() is invoked with constant flags value,
so I think that overhead from this patch may be negligible.
With this patch, code size of vmlinux is reduced slightly.
