Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932327Ab2JJO7h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 10:59:37 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:35195 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932259Ab2JJO7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 10:59:33 -0400
Message-ID: <1349881167.2702.18.camel@lorien2>
Subject: Re: [PATCH v5] dma-debug: New interfaces to debug dma mapping errors
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: konrad.wilk@oracle.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, rob@landley.net, stern@rowland.harvard.edu,
        joerg.roedel@amd.com, bhelgaas@google.com,
        LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
        devel@linuxdriverproject.org, x86@kernel.org, shuahkhan@gmail.com
Date: Wed, 10 Oct 2012 08:59:27 -0600
In-Reply-To: <20121009140605.68b4e6c5.akpm@linux-foundation.org>
References: <1349716086.2674.20.camel@lorien2>
	 <20121009140605.68b4e6c5.akpm@linux-foundation.org>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-09 at 14:06 -0700, Andrew Morton wrote:
> On Mon, 08 Oct 2012 11:08:06 -0600
> Shuah Khan <shuah.khan@hp.com> wrote:
> 
> > Add dma-debug interface debug_dma_mapping_error() to debug drivers that fail
> > to check dma mapping errors on addresses returned by dma_map_single() and
> > dma_map_page() interfaces. This interface clears a flag set by
> > debug_dma_map_page() to indicate that dma_mapping_error() has been called by
> > the driver. When driver does unmap, debug_dma_unmap() checks the flag and if
> > this flag is still set, prints warning message that includes call trace that
> > leads up to the unmap. This interface can be called from dma_mapping_error()
> > routines to enable dma mapping error check debugging.
> > 
> > Tested: Intel iommu and swiotlb (iommu=soft) on x86-64 with
> >         CONFIG_DMA_API_DEBUG enabled and disabled.
> > 
> > Signed-off-by: Shuah Khan <shuah.khan@hp.com>
> > ---
> >  Documentation/DMA-API.txt          |   12 ++++++
> >  arch/x86/include/asm/dma-mapping.h |    1 +
> >  include/linux/dma-debug.h          |    7 ++++
> >  lib/dma-debug.c                    |   71 ++++++++++++++++++++++++++++++++++--
> 
> Third time lucky ... we still haven't fixed Documentation/DMA-API-HOWTO.txt!
> 
> Please, go through it and update it to show people how to correctly use
> these APIs.

Yes. Still on my list. I am working on the documentation changes. I am
planning to add usage examples that include calls to dma_mapping_error()
after dma_map_[page/single] calls and programming mistakes to watch out
for such as missing unmaps from  error legs etc.

-- Shuah


