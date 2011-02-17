Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab1BQWrW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 17:47:22 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46556 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751373Ab1BQWrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 17:47:19 -0500
Date: Thu, 17 Feb 2011 14:46:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Menage <menage@google.com>,
        David Rientjes <rientjes@google.com>,
        =?UTF-8?Q?=E7=BC=AA_=E5=8B=B0?= <miaox@cn.fujitsu.com>,
        linux-mm@kvack.org
Subject: Re: [PATCH 3/4] cpuset: Fix unchecked calls to NODEMASK_ALLOC()
Message-Id: <20110217144643.0d60bef4.akpm@linux-foundation.org>
In-Reply-To: <4D5C7ED1.2070601@cn.fujitsu.com>
References: <4D5C7EA7.1030409@cn.fujitsu.com>
	<4D5C7ED1.2070601@cn.fujitsu.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Feb 2011 09:50:09 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> +/*
> + * In functions that can't propogate errno to users, to avoid declaring a
> + * nodemask_t variable, and avoid using NODEMASK_ALLOC that can return
> + * -ENOMEM, we use this global cpuset_mems.
> + *
> + * It should be used with cgroup_lock held.

I'll do s/should/must/ - that would be a nasty bug.

I'd be more comfortable about the maintainability of this optimisation
if we had

	WARN_ON(!cgroup_is_locked());

at each site.

> + */
> +static nodemask_t cpuset_mems;
