Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab1IFWWD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 18:22:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55176 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750958Ab1IFWV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 18:21:58 -0400
Date: Tue, 6 Sep 2011 15:21:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Menage <paul@paulmenage.org>,
        Li Zefan <lizf@cn.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Tim Hockin <thockin@hockin.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 06/12] cgroups: Add res counter common ancestor
 searching
Message-Id: <20110906152129.c6136981.akpm@linux-foundation.org>
In-Reply-To: <1315267986-28937-7-git-send-email-fweisbec@gmail.com>
References: <1315267986-28937-1-git-send-email-fweisbec@gmail.com>
	<1315267986-28937-7-git-send-email-fweisbec@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  6 Sep 2011 02:13:00 +0200
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> +struct res_counter *
> +res_counter_common_ancestor(struct res_counter *r1, struct res_counter *r2)
> +{
> +	struct res_counter *iter;
> +
> +	while (r1) {
> +		iter = r2;
> +		while (iter) {
> +			if (iter == r1)
> +				return iter;
> +			iter = iter->parent;
> +		}
> +
> +		r1 = r1->parent;
> +	}
> +
> +	return NULL;
> +}

cgroup_mutex, one assumes?
