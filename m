Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab1BHB3V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 20:29:21 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45298 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754425Ab1BHB3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 20:29:20 -0500
Date: Mon, 7 Feb 2011 17:28:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <mszeredi@suse.cz>
Cc: Minchan Kim <minchan.kim@gmail.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH] mm: Add hook of freepage
Message-Id: <20110207172806.dbca2cae.akpm@linux-foundation.org>
In-Reply-To: <1297071421.25994.58.camel@tucsk.pomaz.szeredi.hu>
References: <1297004934-4605-1-git-send-email-minchan.kim@gmail.com>
	<1297071421.25994.58.camel@tucsk.pomaz.szeredi.hu>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 Feb 2011 10:37:01 +0100
Miklos Szeredi <mszeredi@suse.cz> wrote:

> On Mon, 2011-02-07 at 00:08 +0900, Minchan Kim wrote:
> > Recently, "Call the filesystem back whenever a page is removed from
> > the page cache(6072d13c)" added new freepage hook in page cache
> > drop function.
> > 
> > So, replace_page_cache_page should call freepage to support
> > page cleanup to fs.
> 
> Thanks Minchan for fixing this.

What's happening with mm-add-replace_page_cache_page-function.patch,
btw?  When last discussed nearly three weeks ago we had identified:

1) remove radix_tree_preload
2) single radix_tree_lookup_slot and replace radix tree slot
3) page accounting optimization if both pages are in same zone.

