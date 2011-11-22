Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab1KVAhl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 19:37:41 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53423 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701Ab1KVAhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 19:37:40 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 22 Nov 2011 09:36:22 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Balbir Singh <bsingharora@gmail.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, cgroups@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>, mhocko@suse.cz,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH] fix mem_cgroup_split_huge_fixup to work efficiently.
Message-Id: <20111122093622.eba8bbef.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <CAKTCnzk81UiqVHGcTcN_0iyG8dw=-wC6jo8ME7g303PQFKDM3w@mail.gmail.com>
References: <20111117103308.063f78df.kamezawa.hiroyu@jp.fujitsu.com>
	<CAKTCnzk81UiqVHGcTcN_0iyG8dw=-wC6jo8ME7g303PQFKDM3w@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Nov 2011 16:30:11 +0530
Balbir Singh <bsingharora@gmail.com> wrote:

> On Thu, Nov 17, 2011 at 7:03 AM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> >
> > I'll send this again when mm is shipped.
> > I sometimes see mem_cgroup_split_huge_fixup() in perf report and noticed
> > it's very slow. This fixes it. Any comments are welcome.
> >
> 
> How do you see this - what tests?
> 
Sometimes. By applications calling fork() or mremap(), mprotect(), which
will cause split_huge_page(). 
But not 100% reporoducable, yet.

Thanks,
-Kame

