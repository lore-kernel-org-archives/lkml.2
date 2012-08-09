Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030904Ab2HIPM7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 11:12:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29599 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030816Ab2HIPM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 11:12:58 -0400
Date: Thu, 9 Aug 2012 12:12:19 -0300
From: Rafael Aquini <aquini@redhat.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH v6 1/3] mm: introduce compaction and migration for virtio
 ballooned pages
Message-ID: <20120809151218.GB2719@t510.redhat.com>
References: <cover.1344463786.git.aquini@redhat.com>
 <efb9756c5d6de8952a793bfc99a9db9cdd66b12f.1344463786.git.aquini@redhat.com>
 <20120809090019.GB10288@csn.ul.ie>
 <20120809144835.GA2719@t510.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120809144835.GA2719@t510.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2012 at 11:48:36AM -0300, Rafael Aquini wrote:
> Sure! 
> what do you think of:
> 
> +/* putback_lru_page() counterpart for a ballooned page */
> +void putback_balloon_page(struct page *page)
> +{
> +   lock_page(page);
> +   if (!WARN_ON(!movable_balloon_page(page))) {
> +           __putback_balloon_page(page);
> +           put_page(page);
> +   }
> +   unlock_page(page);
> +}
>
Or perhaps
 
+/* putback_lru_page() counterpart for a ballooned page */
+void putback_balloon_page(struct page *page)
+{
+   if (!WARN_ON(!movable_balloon_page(page))) {
+           lock_page(page);
+           __putback_balloon_page(page);
+           put_page(page);
+           unlock_page(page);
+   }
+}

