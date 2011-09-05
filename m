Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab1IEBVT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 21:21:19 -0400
Received: from TYO200.gate.nec.co.jp ([202.32.8.215]:59683 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab1IEBVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 21:21:14 -0400
Date: Mon, 5 Sep 2011 10:16:07 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <bsingharora@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH] memcg: drain all stocks for the cgroup before read
 usage
Message-Id: <20110905101607.cd946a46.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20110905085913.8f84278e.kamezawa.hiroyu@jp.fujitsu.com>
References: <1315098933-29464-1-git-send-email-kirill@shutemov.name>
	<20110905085913.8f84278e.kamezawa.hiroyu@jp.fujitsu.com>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Sep 2011 08:59:13 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Sun,  4 Sep 2011 04:15:33 +0300
> "Kirill A. Shutemov" <kirill@shutemov.name> wrote:
> 
> > From: "Kirill A. Shutemov" <kirill@shutemov.name>
> > 
> > Currently, mem_cgroup_usage() for non-root cgroup returns usage
> > including stocks.
> > 
> > Let's drain all socks before read resource counter value. It makes
> > memory{,.memcg}.usage_in_bytes and memory.stat consistent.
> > 
> > Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
> 
> Hmm. This seems costly to me. 
> 
> If a user chesk usage_in_bytes in a memcg once per 1sec, 
> the kernel will call schedule_work on cpus once per 1sec.
> So, IMHO, I don't like this.
> 
I agree.

We discussed a similar topic on the thread https://lkml.org/lkml/2011/3/18/212.
And, we added the memory.txt:
---
5.5 usage_in_bytes

For efficiency, as other kernel components, memory cgroup uses some optimization
to avoid unnecessary cacheline false sharing. usage_in_bytes is affected by the
method and doesn't show 'exact' value of memory(and swap) usage, it's an fuzz
value for efficient access. (Of course, when necessary, it's synchronized.)
If you want to know more exact memory usage, you should use RSS+CACHE(+SWAP)
value in memory.stat(see 5.2).
---

Thanks,
Daisuke Nishimura.
