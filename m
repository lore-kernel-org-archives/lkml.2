Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000Ab1CBW3k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 17:29:40 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.121]:58497 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988Ab1CBW3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 17:29:39 -0500
X-Authority-Analysis: v=1.1 cv=tLsyj04/L/SH/N6p42ldY6jXDYWe4pX5hAm6uRA1LKo= c=1 sm=0 a=JDAbMbolm0kA:10 a=kj9zAlcOel0A:10 a=ntrFZrGEjHmDqAtCeN43kw==:17 a=qchdqvvUAAAA:8 a=ndjMHKGSrlYcP69dyBcA:9 a=oysiHdlgE47gq-YT76oA:7 a=_k2dwgCeBIZ2HcxqVTvRDUIYDLYA:4 a=CjuIK1q_8ugA:10 a=7G_UksIX704A:10 a=ntrFZrGEjHmDqAtCeN43kw==:117
X-Cloudmark-Score: 0
X-Originating-IP: 76.187.29.95
Date: Wed, 2 Mar 2011 16:29:35 -0600
From: David Engel <david@istwok.net>
To: Greg KH <gregkh@suse.de>
Cc: Stefan Bader <stefan.bader@canonical.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.32.30
Message-ID: <20110302222935.GA21539@opus.istwok.net>
References: <20110302145828.GA4999@kroah.com>
 <4D6E7548.807@canonical.com>
 <20110302204202.GB19022@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110302204202.GB19022@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 03:42:02PM -0500, Greg KH wrote:
> On Wed, Mar 02, 2011 at 05:50:16PM +0100, Stefan Bader wrote:
> > > FUJITA Tomonori (1):
> > >       swiotlb: fix wrong panic
> > >
> > 
> > This one breaks compilation of 64bit for me as swiotlb_tbl_unmap_single() does
> > not exist. It does not look like it is a simple single patch that would get it
> > back to 2.6.32.
> 
> I don't understand.  Is this patch somehow broken?  Is there an
> additional patch I need to apply to fix the build issue?  I need more
> information here.

I think this will fix it.

Fix compilation error introduced in 484d82b6.

do_unmap_single() was renamed to swiotlb_tbl_unmap_single() in
bfc5501f.  Use the old name unless/until that change is also
backported.

Signed-off-by: David Engel <david@istwok.net>

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 7740ee8..0d0df11 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -632,7 +632,7 @@ dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
 	 * Ensure that the address returned is DMA'ble
 	 */
 	if (!dma_capable(dev, dev_addr, size)) {
-		swiotlb_tbl_unmap_single(dev, map, size, dir);
+		do_unmap_single(dev, map, size, dir);
 		dev_addr = swiotlb_virt_to_bus(dev, io_tlb_overflow_buffer);
 	}
 
David
-- 
David Engel
david@istwok.net
