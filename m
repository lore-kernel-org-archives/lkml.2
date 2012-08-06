Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460Ab2HFTBf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 15:01:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932380Ab2HFTBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 15:01:34 -0400
Date: Mon, 6 Aug 2012 16:00:54 -0300
From: Rafael Aquini <aquini@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH v5 1/3] mm: introduce compaction and migration for virtio
 ballooned pages
Message-ID: <20120806190053.GA3968@t510.redhat.com>
References: <cover.1344259054.git.aquini@redhat.com>
 <212b5297df32cb4e3f60d5b76a8cb0629d328a4e.1344259054.git.aquini@redhat.com>
 <50200F1F.7060605@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50200F1F.7060605@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2012 at 02:38:23PM -0400, Rik van Riel wrote:
> On 08/06/2012 09:56 AM, Rafael Aquini wrote:
> 
> >@@ -846,6 +861,21 @@ static int unmap_and_move(new_page_t get_new_page, unsigned long private,
> >  			goto out;
> >
> >  	rc = __unmap_and_move(page, newpage, force, offlining, mode);
> >+
> >+	if (unlikely(is_balloon_page(newpage)&&
> >+		     balloon_compaction_enabled())) {
> 
> Could that be collapsed into one movable_balloon_page(newpage) function
> call?
> 
Keeping is_balloon_page() as is, and itroducing this new movable_balloon_page()
function call, or just doing a plain rename, as Andrew has first suggested?


