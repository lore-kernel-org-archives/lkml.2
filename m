Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757165Ab0GHOFk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 10:05:40 -0400
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:36257 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704Ab0GHOFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 10:05:38 -0400
Date: Thu, 8 Jul 2010 09:04:18 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v2 2/2] vmscan: shrink_slab() require number of lru_pages,
 not page order
In-Reply-To: <20100708163934.CD37.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1007080901460.9707@router.home>
References: <20100708163401.CD34.A69D9226@jp.fujitsu.com> <20100708163934.CD37.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Jul 2010, KOSAKI Motohiro wrote:

> Fix simple argument error. Usually 'order' is very small value than
> lru_pages. then it can makes unnecessary icache dropping.

AFAICT this is not argument error but someone changed the naming of the
parameter. The "lru_pages" parameter is really a division factor affecting
the number of pages scanned. This patch increases this division factor
significantly and therefore reduces the number of items scanned during
zone_reclaim.


