Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847Ab2JIVGJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 17:06:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55645 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497Ab2JIVGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 17:06:07 -0400
Date: Tue, 9 Oct 2012 14:06:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: shuah.khan@hp.com
Cc: konrad.wilk@oracle.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, rob@landley.net, stern@rowland.harvard.edu,
        joerg.roedel@amd.com, bhelgaas@google.com,
        LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
        devel@linuxdriverproject.org, x86@kernel.org, shuahkhan@gmail.com
Subject: Re: [PATCH v5] dma-debug: New interfaces to debug dma mapping
 errors
Message-Id: <20121009140605.68b4e6c5.akpm@linux-foundation.org>
In-Reply-To: <1349716086.2674.20.camel@lorien2>
References: <1349716086.2674.20.camel@lorien2>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 Oct 2012 11:08:06 -0600
Shuah Khan <shuah.khan@hp.com> wrote:

> Add dma-debug interface debug_dma_mapping_error() to debug drivers that fail
> to check dma mapping errors on addresses returned by dma_map_single() and
> dma_map_page() interfaces. This interface clears a flag set by
> debug_dma_map_page() to indicate that dma_mapping_error() has been called by
> the driver. When driver does unmap, debug_dma_unmap() checks the flag and if
> this flag is still set, prints warning message that includes call trace that
> leads up to the unmap. This interface can be called from dma_mapping_error()
> routines to enable dma mapping error check debugging.
> 
> Tested: Intel iommu and swiotlb (iommu=soft) on x86-64 with
>         CONFIG_DMA_API_DEBUG enabled and disabled.
> 
> Signed-off-by: Shuah Khan <shuah.khan@hp.com>
> ---
>  Documentation/DMA-API.txt          |   12 ++++++
>  arch/x86/include/asm/dma-mapping.h |    1 +
>  include/linux/dma-debug.h          |    7 ++++
>  lib/dma-debug.c                    |   71 ++++++++++++++++++++++++++++++++++--

Third time lucky ... we still haven't fixed Documentation/DMA-API-HOWTO.txt!

Please, go through it and update it to show people how to correctly use
these APIs.

