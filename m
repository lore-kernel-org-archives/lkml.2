Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946Ab1FDHZX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 03:25:23 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42746 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185Ab1FDHZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 03:25:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JxGecsayxXrCxux5hlmNYqLGC3eyxxVt67f8UUOncTPyMunRsGBGgJcp9jJVQ0hZ8N
         VxfG0htq6m+Avz1IoJIhGIqhZzEhpfdhTFbd6OM3t3ghNtX5BLGruAhrfxy0NYiN2imn
         rkTt2q+FpUrpl7SzULJvboQ9IZqB5HSwi2D30=
Date: Sat, 4 Jun 2011 16:25:12 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>, akpm@linux-foundation.org,
        Ury Stankevich <urykhy@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@kernel.org
Subject: Re: [PATCH] mm: compaction: Abort compaction if too many pages are
 isolated and caller is asynchronous
Message-ID: <20110604072512.GB4114@barrios-laptop>
References: <20110601191529.GY19505@random.random>
 <20110601214018.GC7306@suse.de>
 <20110601233036.GZ19505@random.random>
 <20110602010352.GD7306@suse.de>
 <20110602132954.GC19505@random.random>
 <20110602145019.GG7306@suse.de>
 <20110602153754.GF19505@random.random>
 <20110603020920.GA26753@suse.de>
 <20110603144941.GI7306@suse.de>
 <20110603154554.GK2802@random.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110603154554.GK2802@random.random>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 03, 2011 at 05:45:54PM +0200, Andrea Arcangeli wrote:
> On Fri, Jun 03, 2011 at 03:49:41PM +0100, Mel Gorman wrote:
> > Right idea of the wrong zone being accounted for but wrong place. I
> > think the following patch should fix the problem;
> 
> Looks good thanks.
> 
> I also found this bug during my debugging that made NR_SHMEM underflow.
> 
> ===
> Subject: migrate: don't account swapcache as shmem
> 
> From: Andrea Arcangeli <aarcange@redhat.com>
> 
> swapcache will reach the below code path in migrate_page_move_mapping,
> and swapcache is accounted as NR_FILE_PAGES but it's not accounted as
> NR_SHMEM.
> 
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

Nice catch!
-- 
Kind regards
Minchan Kim
