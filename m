Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024Ab2JVObq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 10:31:46 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:39545 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754719Ab2JVObp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 10:31:45 -0400
Date: Mon, 22 Oct 2012 14:31:43 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <js1304@gmail.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH for-v3.7 2/2] slub: optimize kmalloc* inlining for
 GFP_DMA
In-Reply-To: <1350748093-7868-2-git-send-email-js1304@gmail.com>
Message-ID: <0000013a88e2e9dc-9f72abd3-9a31-454c-b70b-9937ba54c0ee-000000@email.amazonses.com>
References: <Yes> <1350748093-7868-1-git-send-email-js1304@gmail.com> <1350748093-7868-2-git-send-email-js1304@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Oct 2012, Joonsoo Kim wrote:

> kmalloc() and kmalloc_node() of the SLUB isn't inlined when @flags = __GFP_DMA.
> This patch optimize this case,
> so when @flags = __GFP_DMA, it will be inlined into generic code.

__GFP_DMA is a rarely used flag for kmalloc allocators and so far it was
not considered that it is worth to directly support it in the inlining
code.


