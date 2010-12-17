Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352Ab0LQPwD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 10:52:03 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:40570 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391Ab0LQPwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 10:52:02 -0500
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: miklos@szeredi.hu, akpm@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
In-reply-to: <20101217090103.2a9ca19a.kamezawa.hiroyu@jp.fujitsu.com> (message
	from KAMEZAWA Hiroyuki on Fri, 17 Dec 2010 09:01:03 +0900)
Subject: Re: [PATCH] mm: add replace_page_cache_page() function
References: <E1PStc6-0006Cd-0Z@pomaz-ex.szeredi.hu>
	<20101216100744.e3a417cf.kamezawa.hiroyu@jp.fujitsu.com>
	<E1PTCae-0007tw-Un@pomaz-ex.szeredi.hu> <20101217090103.2a9ca19a.kamezawa.hiroyu@jp.fujitsu.com>
Message-Id: <E1PTcau-0001aw-60@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 17 Dec 2010 16:51:44 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Dec 2010, KAMEZAWA Hiroyuki wrote:
> No. memory cgroup expects all pages should be found on LRU. But, IIUC,
> pages on this radix-tree will not be on LRU. So, memory cgroup can't find
> it at destroying cgroup and can't reduce "usage" of resource to be 0.
> This makes rmdir() returns -EBUSY.

Oh, right.  Yes, the page will be on the LRU (it needs to be,
otherwise the VM coulnd't reclaim it).  After the
add_to_page_cache_locked is this:

	if (!(buf->flags & PIPE_BUF_FLAG_LRU))
		lru_cache_add_file(newpage);

It will add the page to the LRU, unless it's already on it.

Thanks,
Miklos
