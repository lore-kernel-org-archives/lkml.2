Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab2HCRj3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 13:39:29 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49726 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062Ab2HCRjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 13:39:16 -0400
Subject: Re: [RFC v2 1/7] hashtable: introduce a small and naive hashtable
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: torvalds@linux-foundation.org, tj@kernel.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        paul.gortmaker@windriver.com, davem@davemloft.net, rostedt@goodmis.org,
        mingo@elte.hu, ebiederm@xmission.com, aarcange@redhat.com,
        ericvh@gmail.com, netdev@vger.kernel.org
In-Reply-To: <1344003788-1417-2-git-send-email-levinsasha928@gmail.com>
References: <1344003788-1417-1-git-send-email-levinsasha928@gmail.com>
	 <1344003788-1417-2-git-send-email-levinsasha928@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 03 Aug 2012 19:39:10 +0200
Message-ID: <1344015550.9299.1387.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-08-03 at 16:23 +0200, Sasha Levin wrote:
> This hashtable implementation is using hlist buckets to provide a simple
> hashtable to prevent it from getting reimplemented all over the kernel.
> 

> +static void hash_add(struct hash_table *ht, struct hlist_node *node, long key)
> +{
> +	hlist_add_head(node,
> +		&ht->buckets[hash_long((unsigned long)key, HASH_BITS(ht))]);
> +}
> +

Why key is a long, casted later to "unsigned long" ?

hash_long() is expensive on 64bit arches, and not really needed
if key is an u32 from the beginning ( I am referring to your patches 6 &
7 using jhash()  )

Maybe you could use a macro, so that we can automatically select
hash_32() if key is an u32, and hash_long() for other types.



