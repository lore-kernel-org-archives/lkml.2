Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184Ab1IGVdo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 17:33:44 -0400
Received: from shutemov.name ([188.40.19.243]:43881 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757167Ab1IGVdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 17:33:41 -0400
Date: Thu, 8 Sep 2011 00:33:40 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <bsingharora@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: drain all stocks for the cgroup before read usage
Message-ID: <20110907213340.GA7690@shutemov.name>
References: <1315098933-29464-1-git-send-email-kirill@shutemov.name>
 <20110905085913.8f84278e.kamezawa.hiroyu@jp.fujitsu.com>
 <20110905101607.cd946a46.nishimura@mxp.nes.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110905101607.cd946a46.nishimura@mxp.nes.nec.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 05, 2011 at 10:16:07AM +0900, Daisuke Nishimura wrote:
> On Mon, 5 Sep 2011 08:59:13 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > On Sun,  4 Sep 2011 04:15:33 +0300
> > "Kirill A. Shutemov" <kirill@shutemov.name> wrote:
> > 
> > > From: "Kirill A. Shutemov" <kirill@shutemov.name>
> > > 
> > > Currently, mem_cgroup_usage() for non-root cgroup returns usage
> > > including stocks.
> > > 
> > > Let's drain all socks before read resource counter value. It makes
> > > memory{,.memcg}.usage_in_bytes and memory.stat consistent.
> > > 
> > > Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
> > 
> > Hmm. This seems costly to me. 
> > 
> > If a user chesk usage_in_bytes in a memcg once per 1sec, 
> > the kernel will call schedule_work on cpus once per 1sec.
> > So, IMHO, I don't like this.
> > 
> I agree.
> 
> We discussed a similar topic on the thread https://lkml.org/lkml/2011/3/18/212.
> And, we added the memory.txt:
> ---
> 5.5 usage_in_bytes
> 
> For efficiency, as other kernel components, memory cgroup uses some optimization
> to avoid unnecessary cacheline false sharing. usage_in_bytes is affected by the
> method and doesn't show 'exact' value of memory(and swap) usage, it's an fuzz
> value for efficient access. (Of course, when necessary, it's synchronized.)
> If you want to know more exact memory usage, you should use RSS+CACHE(+SWAP)
> value in memory.stat(see 5.2).
> ---

Agree, thanks.

Should we have field 'ram' (or 'memory') for rss+cache in memory.stat?

-- 
 Kirill A. Shutemov
