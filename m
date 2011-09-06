Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370Ab1IFWS1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 18:18:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54428 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750958Ab1IFWSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 18:18:20 -0400
Date: Tue, 6 Sep 2011 15:17:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Menage <paul@paulmenage.org>,
        Li Zefan <lizf@cn.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Tim Hockin <thockin@hockin.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 02/12] cgroups: New resource counter inheritance API
Message-Id: <20110906151747.26aa4fd2.akpm@linux-foundation.org>
In-Reply-To: <1315267986-28937-3-git-send-email-fweisbec@gmail.com>
References: <1315267986-28937-1-git-send-email-fweisbec@gmail.com>
	<1315267986-28937-3-git-send-email-fweisbec@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  6 Sep 2011 02:12:56 +0200
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> +void res_counter_inherit(struct res_counter *counter, int member)
> +{
> +	struct res_counter *parent;
> +	unsigned long long val;
> +
> +	parent = counter->parent;
> +	if (parent) {
> +		val = res_counter_read_u64(parent, member);
> +		res_counter_write_u64(counter, member, val);
> +	}
> +}

What locking protects the read-modify-write?  If none, please fix,
otherwise please document it.

All of kernel/res_counter.c is charmingly undocumented.
