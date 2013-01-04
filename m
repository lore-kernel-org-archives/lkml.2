Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041Ab3ADCvJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 21:51:09 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:54368 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783Ab3ADCvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 21:51:07 -0500
X-AuditID: 9c930179-b7becae000000e51-74-50e6439a7296
Date: Fri, 4 Jan 2013 11:51:05 +0900
From: Minchan Kim <minchan@kernel.org>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFC 2/8] Don't allow volatile attribute on THP and KSM
Message-ID: <20130104025105.GB2617@blaptop>
References: <1357187286-18759-1-git-send-email-minchan@kernel.org>
 <1357187286-18759-3-git-send-email-minchan@kernel.org>
 <50E5B173.7070807@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50E5B173.7070807@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2013 at 08:27:31AM -0800, Dave Hansen wrote:
> On 01/02/2013 08:28 PM, Minchan Kim wrote:
> > VOLATILE imply the the pages in the range isn't working set any more
> > so it's pointless that make them to THP/KSM.
> 
> One of the points of this implementation is that it be able to preserve
> memory contents when there is no pressure.  If those contents happen to
> contain a THP/KSM page, and there's no pressure, it seems like the right
> thing to do is to leave that memory in place.

Indeed. I should have written more cleary,

Current implementation is following as

1. madvised-THP/KSM(1, 10) -> mvolatile(1, 10) -> fail
2. mvolatile(1, 10) -> madvised-THP/KSM(1, 10) -> fail
3. always-THP -> mvolatile -> success -> if memory pressure happens
   -> split_huge_page -> discard.

I think 2,3 makes sense to me but we need to fix 1 in further patches.

> 
> It might be a fair thing to do this in order to keep the implementation
> more sane at the moment.  But, we should make sure there's some good
> text on that in the changelog.

Absolutely, Thanks for pointing out, Dave.

> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Kind regards,
Minchan Kim
