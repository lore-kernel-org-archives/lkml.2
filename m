Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754Ab1KULAO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 06:00:14 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39639 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755341Ab1KULAN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 06:00:13 -0500
MIME-Version: 1.0
In-Reply-To: <20111117103308.063f78df.kamezawa.hiroyu@jp.fujitsu.com>
References: <20111117103308.063f78df.kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 21 Nov 2011 16:30:11 +0530
Message-ID: <CAKTCnzk81UiqVHGcTcN_0iyG8dw=-wC6jo8ME7g303PQFKDM3w@mail.gmail.com>
Subject: Re: [PATCH] fix mem_cgroup_split_huge_fixup to work efficiently.
From: Balbir Singh <bsingharora@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, cgroups@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>, mhocko@suse.cz,
        Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 17, 2011 at 7:03 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
> I'll send this again when mm is shipped.
> I sometimes see mem_cgroup_split_huge_fixup() in perf report and noticed
> it's very slow. This fixes it. Any comments are welcome.
>

How do you see this - what tests?

> ==
> Subject: [PATCH] fix mem_cgroup_split_huge_fixup to work efficiently.
>
> at split_huge_page(), mem_cgroup_split_huge_fixup() is called to
> handle page_cgroup modifcations. It takes move_lock_page_cgroup()
> and modify page_cgroup and LRU accounting jobs and called
> HPAGE_PMD_SIZE - 1 times.
>
> But thinking again,
>  - compound_lock() is held at move_accout...then, it's not necessary
>    to take move_lock_page_cgroup().
>  - LRU is locked and all tail pages will go into the same LRU as
>    head is now on.
>  - page_cgroup is contiguous in huge page range.
>
> This patch fixes mem_cgroup_split_huge_fixup() as to be called once per
> hugepage and reduce costs for spliting.

The change seems reasonable, I am working on a test setup and hope to
test it soon

Balbir
