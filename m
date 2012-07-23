Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab2GWAqt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 20:46:49 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:59311 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818Ab2GWAqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 20:46:31 -0400
X-AuditID: 9c930197-b7b66ae000006a2c-9f-500c9ee52172
Date: Mon, 23 Jul 2012 09:46:46 +0900
From: Minchan Kim <minchan@kernel.org>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] zsmalloc: add page table mapping method
Message-ID: <20120723004646.GD4037@bbox>
References: <1342630556-28686-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <1342630556-28686-3-git-send-email-sjenning@linux.vnet.ibm.com>
 <20120723002655.GC4037@bbox>
 <500C9BE4.70108@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <500C9BE4.70108@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Seth,

On Sun, Jul 22, 2012 at 07:33:40PM -0500, Seth Jennings wrote:
> On 07/22/2012 07:26 PM, Minchan Kim wrote:
> > On Wed, Jul 18, 2012 at 11:55:56AM -0500, Seth Jennings wrote:
> >> This patchset provides page mapping via the page table.
> >> On some archs, most notably ARM, this method has been
> >> demonstrated to be faster than copying.
> >>
> >> The logic controlling the method selection (copy vs page table)
> >> is controlled by the definition of USE_PGTABLE_MAPPING which
> >> is/can be defined for any arch that performs better with page
> >> table mapping.
> >>
> >> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
> >> ---
> >>  drivers/staging/zsmalloc/zsmalloc-main.c |  182 ++++++++++++++++++++++--------
> >>  drivers/staging/zsmalloc/zsmalloc_int.h  |    6 -
> >>  2 files changed, 134 insertions(+), 54 deletions(-)
> >>
> >> diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c b/drivers/staging/zsmalloc/zsmalloc-main.c
> >> index b86133f..defe350 100644
> >> --- a/drivers/staging/zsmalloc/zsmalloc-main.c
> >> +++ b/drivers/staging/zsmalloc/zsmalloc-main.c
> >> @@ -89,6 +89,30 @@
> >>  #define CLASS_IDX_MASK	((1 << CLASS_IDX_BITS) - 1)
> >>  #define FULLNESS_MASK	((1 << FULLNESS_BITS) - 1)
> >>  
> >> +/*
> >> + * By default, zsmalloc uses a copy-based object mapping method to access
> >> + * allocations that span two pages. However, if a particular architecture
> >> + * 1) Implements local_flush_tlb_kernel_range() and 2) Performs VM mapping
> >> + * faster than copying, then it should be added here so that
> > 
> > How about adding your benchmark url?
> > 
> >> + * USE_PGTABLE_MAPPING is defined. This causes zsmalloc to use page table
> >> + * mapping rather than copying
> >> + * for object mapping.
> > 
> > unnecessary new line.
> 
> Since these aren't functional issues with the code, if I
> _promise_ to send a follow-up patch to address these, can I
> get your Ack?

Sure!

Thanks for your effort!

-- 
Kind regards,
Minchan Kim
