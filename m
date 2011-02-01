Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407Ab1BAVWM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 16:22:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24949 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824Ab1BAVWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 16:22:11 -0500
Date: Tue, 1 Feb 2011 16:18:59 -0500
From: Chuck Ebbert <cebbert@redhat.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: hancockrwd@gmail.com, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org
Subject: Re: b44 driver causes panic when using swiotlb
Message-ID: <20110201161859.467676b0@katamari>
In-Reply-To: <20110201102707C.fujita.tomonori@lab.ntt.co.jp>
References: <20110131105412.7252a09c@katamari>
	<20110131163639.GA32095@tassilo.jf.intel.com>
	<4D4759BD.2000006@gmail.com>
	<20110201102707C.fujita.tomonori@lab.ntt.co.jp>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Feb 2011 10:28:00 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> 
> swiotlb allocates the bounce buffer when a system boots up. We can't
> allocate much in GFP_DMA. swiotlb uses somewhere under 4GB. So it
> can't help devices that have odd dma_mask (that is, except for 4GB).
> 
> Unfortunately, Such device needs to do own custom bouncing or needs
> their subsystem to does that.

I think we're chasing the wrong problem here.

swiotlb uses alloc_bootmem_low_pages() to try to get buffers as low
in memory as possible. I asked someone who is hitting this bug to
try 2.6.36 and he reports the buffers really are low there:

2.6.36:  5c00000
2.6.37: db600000

So something happened very early in the 2.6.37-rc cycle that changed
this behavior. I tried looking at the bootmem code but could not see
the problem. The only related option I could find in .config was this:

# CONFIG_NO_BOOTMEM is not set

It was set this way in both .36 and .37.
