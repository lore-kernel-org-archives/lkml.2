Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946107Ab2EKVR6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 17:17:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33708 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933263Ab2EKVR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 17:17:56 -0400
Date: Fri, 11 May 2012 14:17:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Han Ying <yinghan@google.com>, Glauber Costa <glommer@parallels.com>,
        Tejun Heo <tj@kernel.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/6] memcg: fix error code in
 hugetlb_force_memcg_empty()
Message-Id: <20120511141754.e0719c26.akpm@linux-foundation.org>
In-Reply-To: <4FACDFAE.5050808@jp.fujitsu.com>
References: <4FACDED0.3020400@jp.fujitsu.com>
	<4FACDFAE.5050808@jp.fujitsu.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2012 18:45:18 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> The conditions are handled as -EBUSY, _now_.

The changelog is poor.  I rewrote it to

: hugetlb_force_memcg_empty() incorrectly returns 0 (success) when the
: cgroup is found to be busy.  Return -EBUSY instead.

But it still doesn't tell us the end-user-visible effects of the bug. 
It should.

