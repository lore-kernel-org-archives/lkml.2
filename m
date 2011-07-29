Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222Ab1G2JzK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 05:55:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55197 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930Ab1G2JzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 05:55:09 -0400
Date: Fri, 29 Jul 2011 10:55:04 +0100
From: Mel Gorman <mgorman@suse.de>
To: Keiichi KII <k-keiichi@bx.jp.nec.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Tom Zanussi <tzanussi@gmail.com>, "riel@redhat.com" <riel@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Fr??d??ric Weisbecker <fweisbec@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        "BA, Moussa" <Moussa.BA@numonyx.com>
Subject: Re: [RFC PATCH -tip 2/5] tracing/mm: add header event for object
 collections
Message-ID: <20110729095504.GQ3010@suse.de>
References: <4E24A61D.4060702@bx.jp.nec.com>
 <4E24A6F5.2080706@bx.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4E24A6F5.2080706@bx.jp.nec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 05:34:45PM -0400, Keiichi KII wrote:
> From: Keiichi Kii <k-keiichi@bx.jp.nec.com>
> 
> We can use this "dump_header" event to separate trace data
> for the object collections.
> 

dump_header is a very generic name. A "header" could apply to almost
anything. Network packets have headers but is unrelated to this.

> Usage and Sample output:
> 
> zsh  2815 [001]  8819.880776: dump_header: object=mm/pages/walk-fs input=/
> zsh  2815 [001]  8819.880786: dump_inode: ino=139161 size=507416 cached=507904 age=29 dirty=7 dev=254:0 file=strchr
> zsh  2815 [001]  8819.880790: dump_pagecache_range: index=0 len=1 flags=4000000000000878 count=2 mapcount=0
> zsh  2815 [001]  8819.880793: dump_pagecache_range: index=1 len=18 flags=400000000000087c count=2 mapcount=0
> zsh  2815 [001]  8819.880795: dump_pagecache_range: index=19 len=1 flags=400000000000083c count=2 mapcount=0
> zsh  2815 [001]  8819.880796: dump_pagecache_range: index=20 len=2 flags=400000000000087c count=2 mapcount=0
> ...
> zsh  2816 [001]  8820.XXXXXX: dump_header: object=mm/pages/walk-fs input=/

Is it possible for other trace information to appear in the middle of
this? In particular, is it possible for a new "dump_header" to appear in
the middle of an existing dump?

> Signed-off-by: Keiichi Kii <k-keiichi@bx.jp.nec.com>
> ---
> 
>  include/trace/events/mm.h |   19 +++++++++++++++++++
>  kernel/trace/trace_mm.c   |    9 +++++++++
>  2 files changed, 28 insertions(+), 0 deletions(-)
> 

Where are these files? Your leader makes reference to latest linux-tip
but there are a few trees called linux-tip. Even then, which latest
branch? I dug through Ingo's linux-tip tree but couldn't find where the
dump_inode tracepoint was to look at it so I couldn't review the
changes. Sorry if I missed something obvious :(

-- 
Mel Gorman
SUSE Labs
