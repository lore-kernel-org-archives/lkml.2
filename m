Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758793Ab2FVWLZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 18:11:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51428 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754339Ab2FVWLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 18:11:23 -0400
Date: Fri, 22 Jun 2012 15:11:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Li Zefan <lizefan@huawei.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, <linux-mm@kvack.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, <dhillf@gmail.com>,
        <rientjes@google.com>, <mhocko@suse.cz>, <hannes@cmpxchg.org>,
        <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>
Subject: Re: [PATCH -V9 11/15] hugetlb/cgroup: Add charge/uncharge routines
 for hugetlb cgroup
Message-Id: <20120622151121.917178eb.akpm@linux-foundation.org>
In-Reply-To: <4FD9A79D.9030303@huawei.com>
References: <1339583254-895-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<1339583254-895-12-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<4FD9A79D.9030303@huawei.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jun 2012 16:58:05 +0800
Li Zefan <lizefan@huawei.com> wrote:

> > +int hugetlb_cgroup_charge_cgroup(int idx, unsigned long nr_pages,
> 
> > +				 struct hugetlb_cgroup **ptr)
> > +{
> > +	int ret = 0;
> > +	struct res_counter *fail_res;
> > +	struct hugetlb_cgroup *h_cg = NULL;
> > +	unsigned long csize = nr_pages * PAGE_SIZE;
> > +
> > +	if (hugetlb_cgroup_disabled())
> > +		goto done;
> > +	/*
> > +	 * We don't charge any cgroup if the compound page have less
> > +	 * than 3 pages.
> > +	 */
> > +	if (huge_page_order(&hstates[idx]) < HUGETLB_CGROUP_MIN_ORDER)
> > +		goto done;
> > +again:
> > +	rcu_read_lock();
> > +	h_cg = hugetlb_cgroup_from_task(current);
> > +	if (!h_cg)
> 
> 
> In no circumstances should h_cg be NULL.
> 

Aneesh?
