Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab2F2DwM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 23:52:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3982 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354Ab2F2DwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 23:52:11 -0400
Date: Fri, 29 Jun 2012 00:51:24 -0300
From: Rafael Aquini <aquini@redhat.com>
To: Minchan Kim <minchan@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>, Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH v2 0/4] make balloon pages movable by compaction
Message-ID: <20120629035123.GA1763@t510.redhat.com>
References: <cover.1340916058.git.aquini@redhat.com>
 <4FED06C8.1090003@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FED06C8.1090003@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 29, 2012 at 10:37:12AM +0900, Minchan Kim wrote:
> Hi Rafael,
> 
> On 06/29/2012 06:49 AM, Rafael Aquini wrote:
> 
> > This patchset follows the main idea discussed at 2012 LSFMMS section:
> > "Ballooning for transparent huge pages" -- http://lwn.net/Articles/490114/
> 
> 
> Could you summarize the problem, solution instead of link URL in cover-letter?
> IIUC, the problem is that it is hard to get contiguous memory in guest-side 
> after ballooning happens because guest-side memory could be very fragmented
> by ballooned page. It makes THP page allocation of guest-side very poor success ratio.
> 
> The solution is that when memory ballooning happens, we allocates ballooned page
> as a movable page in guest-side because they can be migrated easily so compaction of
> guest-side could put together them into either side so that we can get contiguous memory.
> For it, compaction should be aware of ballooned page.
> 
> Right?
>
Yes, you surely got it correct, sir. 

Thanks Minchan, for taking time to provide me such feedback. I'll rework commit
messages to make them more elucidative, yet concise for the next submission.

Please, let me know if you have other concerns I shall be addressing here.

Best regards!
