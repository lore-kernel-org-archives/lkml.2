Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387Ab1D1JmZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 05:42:25 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38136 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200Ab1D1JmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 05:42:24 -0400
Date: Thu, 28 Apr 2011 10:42:15 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC] ARM DMA mapping TODO, v1
Message-ID: <20110428094215.GW17290@n2100.arm.linux.org.uk>
References: <201104212129.17013.arnd@arndb.de> <1303939866.2513.180.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303939866.2513.180.camel@pasglop>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 07:31:06AM +1000, Benjamin Herrenschmidt wrote:
> The question remains, if we ever want to do more complex demand-paged
> operations, should we also expose a lower level set of functions to get
> struct page out of a dma_alloc_coherent() allocation and to get the
> pgprot for the user dma mapping ?

I don't think so - that places the requirement that dma_alloc_coherent()
must be backed by memory with a set of struct page, which may not always
be the case.

Think about dma_alloc_coherent() with dma_declare_coherent_memory() used
with memory which is not part of system RAM.
