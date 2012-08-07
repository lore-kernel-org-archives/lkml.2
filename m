Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932320Ab2HGBxo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 21:53:44 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46271 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932086Ab2HGBxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 21:53:42 -0400
Message-ID: <5020754A.6090906@gmail.com>
Date: Tue, 07 Aug 2012 03:54:18 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120730 Thunderbird/14.0
MIME-Version: 1.0
To: Li Wei <lw@cn.fujitsu.com>
CC: torvalds@linux-foundation.org, tj@kernel.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        paul.gortmaker@windriver.com, davem@davemloft.net, rostedt@goodmis.org,
        mingo@elte.hu, ebiederm@xmission.com, aarcange@redhat.com,
        ericvh@gmail.com, netdev@vger.kernel.org, josh@joshtriplett.org,
        eric.dumazet@gmail.com, mathieu.desnoyers@efficios.com
Subject: Re: [RFC v3 1/7] hashtable: introduce a small and naive hashtable
References: <1344300317-23189-1-git-send-email-levinsasha928@gmail.com> <1344300317-23189-2-git-send-email-levinsasha928@gmail.com> <502073E9.8050205@cn.fujitsu.com>
In-Reply-To: <502073E9.8050205@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2012 03:48 AM, Li Wei wrote:
> On 08/07/2012 08:45 AM, Sasha Levin wrote:
>> +/**
>> + * hash_for_each - iterate over a hashtable
>> + * @name: hashtable to iterate
>> + * @bits: bit count of hashing function of the hashtable
>> + * @bkt: integer to use as bucket loop cursor
>> + * @node: the &struct list_head to use as a loop cursor for each bucket
>> + * @obj: the type * to use as a loop cursor for each bucket
>> + * @member: the name of the hlist_node within the struct
>> + */
>> +#define hash_for_each(name, bits, bkt, node, obj, member)		\
>> +	for (bkt = 0; bkt < HASH_SIZE(bits); bkt++)			\
>> +		hlist_for_each_entry(obj, node, &name[i], member)
> 
> Where is the 'i' coming from? maybe &name[bkt]?

Heh, yeah. And the only place that uses this macro had 'i' declared as the loop counter, so it didn't trigger any issues during testing.

Thanks!

