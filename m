Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab2ATJu7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 04:50:59 -0500
Received: from shutemov.name ([176.9.204.213]:40835 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752246Ab2ATJu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 04:50:58 -0500
X-Greylist: delayed 525 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Jan 2012 04:50:57 EST
Date: Fri, 20 Jan 2012 11:42:38 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH trivial] mm: make get_mm_counter static-inline
Message-ID: <20120120094238.GA16009@shutemov.name>
References: <20120119124005.21946.18651.stgit@zurg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120119124005.21946.18651.stgit@zurg>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 04:40:05PM +0400, Konstantin Khlebnikov wrote:
> This patch makes get_mm_counter() always static inline,
> it is simple enough for that. And remove unused set_mm_counter()
> 
> bloat-o-meter:
> 
> add/remove: 0/1 grow/shrink: 4/12 up/down: 99/-341 (-242)
> function                                     old     new   delta
> try_to_unmap_one                             886     952     +66
> sys_remap_file_pages                        1214    1230     +16
> dup_mm                                      1684    1700     +16
> do_exit                                     2277    2278      +1
> zap_page_range                               208     205      -3
> unmap_region                                 304     296      -8
> static.oom_kill_process                      554     546      -8
> try_to_unmap_file                           1716    1700     -16
> getrusage                                    925     909     -16
> flush_old_exec                              1704    1688     -16
> static.dump_header                           416     390     -26
> acct_update_integrals                        218     187     -31
> do_task_stat                                2986    2954     -32
> get_mm_counter                                34       -     -34
> xacct_add_tsk                                371     334     -37
> task_statm                                   172     118     -54
> task_mem                                     383     323     -60
> 
> try_to_unmap_one() grows because update_hiwater_rss() now completely inline.
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>

Acked-by: Kirill A. Shutemov <kirill@shutemov.name>

-- 
 Kirill A. Shutemov
