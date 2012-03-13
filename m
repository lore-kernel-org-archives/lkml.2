Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759625Ab2CMVdV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 17:33:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49261 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853Ab2CMVdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 17:33:18 -0400
Date: Tue, 13 Mar 2012 14:33:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com,
        dhillf@gmail.com, aarcange@redhat.com, mhocko@suse.cz,
        hannes@cmpxchg.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org
Subject: Re: [PATCH -V3 2/8] memcg: Add HugeTLB extension
Message-Id: <20120313143316.0ef74d0e.akpm@linux-foundation.org>
In-Reply-To: <1331622432-24683-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1331622432-24683-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<1331622432-24683-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Mar 2012 12:37:06 +0530
"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:

> +static int mem_cgroup_hugetlb_usage(struct mem_cgroup *memcg)
> +{
> +	int idx;
> +	for (idx = 0; idx < hugetlb_max_hstate; idx++) {
> +		if (memcg->hugepage[idx].usage > 0)
> +			return memcg->hugepage[idx].usage;
> +	}
> +	return 0;
> +}

Please document the function?  Had you done this, I might have been
able to work out why the function bales out on the first used hugepage
size, but I can't :(

This could have used for_each_hstate(), had that macro been better
designed (or updated).

Upon return this function coerces an unsigned long long into an "int". 
We decided last week that more than 2^32 hugepages was not
inconceivable, so I guess that's a bug.

