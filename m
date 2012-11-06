Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab2KFAdQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 19:33:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56348 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001Ab2KFAdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 19:33:15 -0500
Date: Mon, 5 Nov 2012 16:33:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Glauber Costa <glommer@parallels.com>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH v6 20/29] memcg: skip memcg kmem allocations in
 specified code regions
Message-Id: <20121105163313.c555a2b1.akpm@linux-foundation.org>
In-Reply-To: <1351771665-11076-21-git-send-email-glommer@parallels.com>
References: <1351771665-11076-1-git-send-email-glommer@parallels.com>
	<1351771665-11076-21-git-send-email-glommer@parallels.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  1 Nov 2012 16:07:36 +0400
Glauber Costa <glommer@parallels.com> wrote:

> This patch creates a mechanism that skip memcg allocations during
> certain pieces of our core code. It basically works in the same way
> as preempt_disable()/preempt_enable(): By marking a region under
> which all allocations will be accounted to the root memcg.
> 
> We need this to prevent races in early cache creation, when we
> allocate data using caches that are not necessarily created already.
> 
> ...
>
> +static inline void memcg_stop_kmem_account(void)
> +{
> +	if (!current->mm)
> +		return;

It is utterly unobvious to this reader why the code tests ->mm in this
fashion.  So we need either smarter readers or a code comment.

