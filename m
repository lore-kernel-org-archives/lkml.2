Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932577Ab0LTAAI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 19:00:08 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35995 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932536Ab0LTAAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 19:00:06 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 20 Dec 2010 08:54:13 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: add replace_page_cache_page() function
Message-Id: <20101220085413.b83d1093.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <E1PTcau-0001aw-60@pomaz-ex.szeredi.hu>
References: <E1PStc6-0006Cd-0Z@pomaz-ex.szeredi.hu>
	<20101216100744.e3a417cf.kamezawa.hiroyu@jp.fujitsu.com>
	<E1PTCae-0007tw-Un@pomaz-ex.szeredi.hu>
	<20101217090103.2a9ca19a.kamezawa.hiroyu@jp.fujitsu.com>
	<E1PTcau-0001aw-60@pomaz-ex.szeredi.hu>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Dec 2010 16:51:44 +0100
Miklos Szeredi <miklos@szeredi.hu> wrote:

> On Fri, 17 Dec 2010, KAMEZAWA Hiroyuki wrote:
> > No. memory cgroup expects all pages should be found on LRU. But, IIUC,
> > pages on this radix-tree will not be on LRU. So, memory cgroup can't find
> > it at destroying cgroup and can't reduce "usage" of resource to be 0.
> > This makes rmdir() returns -EBUSY.
> 
> Oh, right.  Yes, the page will be on the LRU (it needs to be,
> otherwise the VM coulnd't reclaim it).  After the
> add_to_page_cache_locked is this:
> 
> 	if (!(buf->flags & PIPE_BUF_FLAG_LRU))
> 		lru_cache_add_file(newpage);
> 
> It will add the page to the LRU, unless it's already on it.
> 

Thank you for clarification. 

Thanks,
-Kame

