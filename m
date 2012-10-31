Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760714Ab2JaVau (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 17:30:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37611 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527Ab2JaVat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 17:30:49 -0400
Date: Wed, 31 Oct 2012 14:30:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Glauber Costa <glommer@parallels.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>
Subject: Re: [PATCH v3 3/6] memcg: Simplify mem_cgroup_force_empty_list
 error handling
Message-Id: <20121031143047.95587bff.akpm@linux-foundation.org>
In-Reply-To: <20121030103559.GA7394@dhcp22.suse.cz>
References: <1351251453-6140-1-git-send-email-mhocko@suse.cz>
	<1351251453-6140-4-git-send-email-mhocko@suse.cz>
	<508E8B95.406@parallels.com>
	<20121029150022.a595b866.akpm@linux-foundation.org>
	<20121030103559.GA7394@dhcp22.suse.cz>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Oct 2012 11:35:59 +0100
Michal Hocko <mhocko@suse.cz> wrote:

> > If the kernel is uniprocessor and the caller is SCHED_FIFO: ad infinitum!
>
> ...
>
> Can we consider this as a corner case (it is much easier to kill a
> machine with SCHED_FIFO than this anyway) or the concern is really
> strong and we should come with a solution before this can get merged?

Sure.  SCHED_FIFO can be used to permanently block all kernel threads
which pretty quickly results in a very sick kernel.  My observation was
just a general moan about the SCHED_FIFO wontfix problem :)

