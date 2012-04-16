Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292Ab2DPXN5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 19:13:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38801 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab2DPXN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 19:13:56 -0400
Date: Mon, 16 Apr 2012 16:13:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com,
        dhillf@gmail.com, aarcange@redhat.com, mhocko@suse.cz,
        hannes@cmpxchg.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org
Subject: Re: [PATCH -V6 10/14] hugetlbfs: Add memcg control files for
 hugetlbfs
Message-Id: <20120416161354.b967790c.akpm@linux-foundation.org>
In-Reply-To: <1334573091-18602-11-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1334573091-18602-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<1334573091-18602-11-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Apr 2012 16:14:47 +0530
"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:

> +#ifdef CONFIG_MEM_RES_CTLR_HUGETLB
> +static char *mem_fmt(char *buf, unsigned long n)
> +{
> +	if (n >= (1UL << 30))
> +		sprintf(buf, "%luGB", n >> 30);
> +	else if (n >= (1UL << 20))
> +		sprintf(buf, "%luMB", n >> 20);
> +	else
> +		sprintf(buf, "%luKB", n >> 10);
> +	return buf;
> +}
> +
> +int __init mem_cgroup_hugetlb_file_init(int idx)
> +{
> +	char buf[32];
> +	struct cftype *cft;
> +	struct hstate *h = &hstates[idx];
> +
> +	/* format the size */
> +	mem_fmt(buf, huge_page_size(h));

The sprintf() into a fixed-sized buffer is a bit ugly.  I didn't check
it for possible overflows because 32 looks like "enough".  Actually too
much.

Oh well, it's hard to avoid.  But using scnprintf() would prevent nasty
accidents.

