Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932604Ab2HGCzb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 22:55:31 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:57613 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999Ab2HGCza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 22:55:30 -0400
X-Originating-IP: 217.70.178.134
X-Originating-IP: 50.43.46.74
Date: Mon, 6 Aug 2012 19:55:20 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: torvalds@linux-foundation.org, tj@kernel.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        paul.gortmaker@windriver.com, davem@davemloft.net, rostedt@goodmis.org,
        mingo@elte.hu, ebiederm@xmission.com, aarcange@redhat.com,
        ericvh@gmail.com, netdev@vger.kernel.org, eric.dumazet@gmail.com,
        mathieu.desnoyers@efficios.com
Subject: Re: [RFC v3 1/7] hashtable: introduce a small and naive hashtable
Message-ID: <20120807025520.GA3823@leaf>
References: <1344300317-23189-1-git-send-email-levinsasha928@gmail.com>
 <1344300317-23189-2-git-send-email-levinsasha928@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344300317-23189-2-git-send-email-levinsasha928@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 02:45:10AM +0200, Sasha Levin wrote:
> +/**
> + * hash_add - add an object to a hashtable
> + * @hashtable: hashtable to add to
> + * @bits: bit count used for hashing
> + * @node: the &struct hlist_node of the object to be added
> + * @key: the key of the object to be added
> + */
> +#define hash_add(hashtable, bits, node, key)				\
> +	hlist_add_head(node, &hashtable[hash_min(key, bits)]);

Any particular reason to make this a macro rather than a static inline?

Also, even if you do make it a macro, don't include the semicolon.

> +/**
> + * hash_for_each_possible - iterate over all possible objects for a giver key

s/giver/given/

> + * @name: hashtable to iterate
> + * @obj: the type * to use as a loop cursor for each bucke

s/bucke/bucket/

- Josh Triplett
