Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324Ab1LUGWn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 01:22:43 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:62195 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab1LUGWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 01:22:40 -0500
Date: Wed, 21 Dec 2011 15:22:32 +0900
From: Minchan Kim <minchan@kernel.org>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vmalloc: remove #ifdef in function body
Message-ID: <20111221062232.GE28505@barrios-laptop.redhat.com>
References: <1324444679-9247-1-git-send-email-minchan@kernel.org>
 <op.v6tsxbmb3l0zgt@mpn-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <op.v6tsxbmb3l0zgt@mpn-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 07:13:49AM +0100, Michal Nazarewicz wrote:
> On Wed, 21 Dec 2011 06:17:59 +0100, Minchan Kim <minchan@kernel.org> wrote:
> >We don't like function body which include #ifdef.
> >If we can, define null function to go out compile time.
> >It's trivial, no functional change.
> 
> It actually adds “flush_tlb_kenel_range()” call to the function so there
> is functional change.

Sorry. I can't understand your point.
Why does it add flush_tlb_kernel_range in case of !CONFIG_DEBUG_PAGEALLOC?

> 
> >Signed-off-by: Minchan Kim <minchan@kernel.org>
> >---
> > mm/vmalloc.c |    9 +++++++--
> > 1 files changed, 7 insertions(+), 2 deletions(-)
> >
> >diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> >index 0aca3ce..e1fa5a6 100644
> >--- a/mm/vmalloc.c
> >+++ b/mm/vmalloc.c
> >@@ -505,6 +505,7 @@ static void unmap_vmap_area(struct vmap_area *va)
> > 	vunmap_page_range(va->va_start, va->va_end);
> > }
> >+#ifdef CONFIG_DEBUG_PAGEALLOC
> > static void vmap_debug_free_range(unsigned long start, unsigned long end)
> > {
> > 	/*
> >@@ -520,11 +521,15 @@ static void vmap_debug_free_range(unsigned long start, unsigned long end)
> > 	 * debugging doesn't do a broadcast TLB flush so it is a lot
> > 	 * faster).
> > 	 */
> >-#ifdef CONFIG_DEBUG_PAGEALLOC
> > 	vunmap_page_range(start, end);
> > 	flush_tlb_kernel_range(start, end);
> >-#endif
> > }
> >+#else
> >+static inline void vmap_debug_free_range(unsigned long start,
> >+					unsigned long end)
> >+{
> >+}
> >+#endif
> >/*
> >  * lazy_max_pages is the maximum amount of virtual address space we gather up
> 
> -- 
> Best regards,                                         _     _
> .o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
> ..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
> ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--

-- 
Kind regards,
Minchan Kim
