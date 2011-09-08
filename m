Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab1IHAT7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 20:19:59 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59018 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061Ab1IHAT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 20:19:58 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 8 Sep 2011 09:19:14 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <bsingharora@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: drain all stocks for the cgroup before read
 usage
Message-Id: <20110908091914.6daeab1e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110907213340.GA7690@shutemov.name>
References: <1315098933-29464-1-git-send-email-kirill@shutemov.name>
	<20110905085913.8f84278e.kamezawa.hiroyu@jp.fujitsu.com>
	<20110905101607.cd946a46.nishimura@mxp.nes.nec.co.jp>
	<20110907213340.GA7690@shutemov.name>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Sep 2011 00:33:40 +0300
"Kirill A. Shutemov" <kirill@shutemov.name> wrote:

> On Mon, Sep 05, 2011 at 10:16:07AM +0900, Daisuke Nishimura wrote:
> > On Mon, 5 Sep 2011 08:59:13 +0900
> > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > 
> > > On Sun,  4 Sep 2011 04:15:33 +0300
> > > "Kirill A. Shutemov" <kirill@shutemov.name> wrote:
> > > 
> > > > From: "Kirill A. Shutemov" <kirill@shutemov.name>
> > > > 
> > > > Currently, mem_cgroup_usage() for non-root cgroup returns usage
> > > > including stocks.
> > > > 
> > > > Let's drain all socks before read resource counter value. It makes
> > > > memory{,.memcg}.usage_in_bytes and memory.stat consistent.
> > > > 
> > > > Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
> > > 
> > > Hmm. This seems costly to me. 
> > > 
> > > If a user chesk usage_in_bytes in a memcg once per 1sec, 
> > > the kernel will call schedule_work on cpus once per 1sec.
> > > So, IMHO, I don't like this.
> > > 
> > I agree.
> > 
> > We discussed a similar topic on the thread https://lkml.org/lkml/2011/3/18/212.
> > And, we added the memory.txt:
> > ---
> > 5.5 usage_in_bytes
> > 
> > For efficiency, as other kernel components, memory cgroup uses some optimization
> > to avoid unnecessary cacheline false sharing. usage_in_bytes is affected by the
> > method and doesn't show 'exact' value of memory(and swap) usage, it's an fuzz
> > value for efficient access. (Of course, when necessary, it's synchronized.)
> > If you want to know more exact memory usage, you should use RSS+CACHE(+SWAP)
> > value in memory.stat(see 5.2).
> > ---
> 
> Agree, thanks.
> 
> Should we have field 'ram' (or 'memory') for rss+cache in memory.stat?
> 

Why do you think so ?

Thanks,
-Kame


