Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab2HJMqz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 08:46:55 -0400
Received: from gir.skynet.ie ([193.1.99.77]:44109 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744Ab2HJMqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 08:46:53 -0400
Date: Fri, 10 Aug 2012 13:46:49 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Rafael Aquini <aquini@redhat.com>
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
Message-ID: <20120810124649.GL10288@csn.ul.ie>
References: <cover.1344463786.git.aquini@redhat.com>
 <efb9756c5d6de8952a793bfc99a9db9cdd66b12f.1344463786.git.aquini@redhat.com>
 <20120809090019.GB10288@csn.ul.ie>
 <20120809144835.GA2719@t510.redhat.com>
 <20120809151218.GB2719@t510.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20120809151218.GB2719@t510.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2012 at 12:12:19PM -0300, Rafael Aquini wrote:
> On Thu, Aug 09, 2012 at 11:48:36AM -0300, Rafael Aquini wrote:
> > Sure! 
> > what do you think of:
> > 
> > +/* putback_lru_page() counterpart for a ballooned page */
> > +void putback_balloon_page(struct page *page)
> > +{
> > +   lock_page(page);
> > +   if (!WARN_ON(!movable_balloon_page(page))) {
> > +           __putback_balloon_page(page);
> > +           put_page(page);
> > +   }
> > +   unlock_page(page);
> > +}
> >
> Or perhaps
>  
> +/* putback_lru_page() counterpart for a ballooned page */
> +void putback_balloon_page(struct page *page)
> +{
> +   if (!WARN_ON(!movable_balloon_page(page))) {
> +           lock_page(page);
> +           __putback_balloon_page(page);
> +           put_page(page);
> +           unlock_page(page);
> +   }
> +}

That should be fine. I find the WARN_ON construct odd to read but only
because it's unusual. It is more typical to see something like

if (WARN_ON(!movable_balooon_page(page)))
	return;

lock_page(page);
__putback_balloon_page(page);
put_page(page);
unlock_page(page);

but either works. Do not forget to update the caller of course.

Thanks.


-- 
Mel Gorman
SUSE Labs
