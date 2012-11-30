Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203Ab2K3AEp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 19:04:45 -0500
Received: from tetsuo.zabbo.net ([50.193.208.193]:59499 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754521Ab2K3AEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 19:04:44 -0500
Date: Thu, 29 Nov 2012 16:04:43 -0800
From: Zach Brown <zab@zabbo.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Lin Feng <linfeng@cn.fujitsu.com>, viro@zeniv.linux.org.uk, bcrl@kvack.org,
        kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, hughd@google.com,
        cl@linux.com, mgorman@suse.de, minchan@kernel.org,
        isimatu.yasuaki@jp.fujitsu.com, laijs@cn.fujitsu.com,
        wency@cn.fujitsu.com, tangchen@cn.fujitsu.com,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [BUG REPORT] [mm-hotplug, aio] aio ring_pages can't be offlined
Message-ID: <20121130000443.GK18574@lenny.home.zabbo.net>
References: <1354172098-5691-1-git-send-email-linfeng@cn.fujitsu.com>
 <20121129153930.477e9709.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121129153930.477e9709.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The best I can think of is to make changes in or around
> get_user_pages(), to steal the pages from userspace and replace them
> with non-movable ones before pinning them.  The performance cost of
> something like this would surely be unacceptable for direct-io, but
> maybe OK for the aio ring and futexes.

In the aio case it seems like it could be taught to populate the mapping
with non-movable pages to begin with.  It's calling get_user_pages() a
few lines after instantiating the mapping itself with do_mmap_pgoff().

- z
