Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965962Ab2EODCL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 23:02:11 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58643 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965954Ab2EODBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 23:01:54 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FB1C6A1.1020602@jp.fujitsu.com>
Date: Tue, 15 May 2012 11:59:45 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Glauber Costa <glommer@parallels.com>
CC: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, devel@openvz.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Aditya Kali <adityakali@google.com>,
        Oleg Nesterov <oleg@redhat.com>, Kay Sievers <kay.sievers@vrfy.org>,
        Tim Hockin <thockin@hockin.org>, Tejun Heo <htejun@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 11/29] cgroups: ability to stop res charge propagation
 on bounded ancestor
References: <1336758272-24284-1-git-send-email-glommer@parallels.com> <1336758272-24284-12-git-send-email-glommer@parallels.com>
In-Reply-To: <1336758272-24284-12-git-send-email-glommer@parallels.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/05/12 2:44), Glauber Costa wrote:

> From: Frederic Weisbecker <fweisbec@gmail.com>
> 
> Moving a task from a cgroup to another may require to substract its
> resource charge from the old cgroup and add it to the new one.
> 
> For this to happen, the uncharge/charge propagation can just stop when we
> reach the common ancestor for the two cgroups.  Further the performance
> reasons, we also want to avoid to temporarily overload the common
> ancestors with a non-accurate resource counter usage if we charge first
> the new cgroup and uncharge the old one thereafter.  This is going to be a
> requirement for the coming max number of task subsystem.
> 
> To solve this, provide a pair of new API that can charge/uncharge a
> resource counter until we reach a given ancestor.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Acked-by: Paul Menage <paul@paulmenage.org>
> Acked-by: Glauber Costa <glommer@parallels.com>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Aditya Kali <adityakali@google.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Kay Sievers <kay.sievers@vrfy.org>
> Cc: Tim Hockin <thockin@hockin.org>
> Cc: Tejun Heo <htejun@gmail.com>
> Acked-by: Kirill A. Shutemov <kirill@shutemov.name>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>


Where is this function called in this series ?

Thanks,
-Kame

