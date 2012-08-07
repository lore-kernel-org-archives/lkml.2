Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950Ab2HGJtK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 05:49:10 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58158 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815Ab2HGJtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 05:49:07 -0400
Message-ID: <5020E4B5.4040702@gmail.com>
Date: Tue, 07 Aug 2012 11:49:41 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120730 Thunderbird/14.0
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>
CC: torvalds@linux-foundation.org, tj@kernel.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        paul.gortmaker@windriver.com, davem@davemloft.net, rostedt@goodmis.org,
        mingo@elte.hu, ebiederm@xmission.com, aarcange@redhat.com,
        ericvh@gmail.com, netdev@vger.kernel.org, eric.dumazet@gmail.com,
        mathieu.desnoyers@efficios.com
Subject: Re: [RFC v3 1/7] hashtable: introduce a small and naive hashtable
References: <1344300317-23189-1-git-send-email-levinsasha928@gmail.com> <1344300317-23189-2-git-send-email-levinsasha928@gmail.com> <20120807025520.GA3823@leaf>
In-Reply-To: <20120807025520.GA3823@leaf>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2012 04:55 AM, Josh Triplett wrote:
> On Tue, Aug 07, 2012 at 02:45:10AM +0200, Sasha Levin wrote:
>> +/**
>> + * hash_add - add an object to a hashtable
>> + * @hashtable: hashtable to add to
>> + * @bits: bit count used for hashing
>> + * @node: the &struct hlist_node of the object to be added
>> + * @key: the key of the object to be added
>> + */
>> +#define hash_add(hashtable, bits, node, key)				\
>> +	hlist_add_head(node, &hashtable[hash_min(key, bits)]);
> 
> Any particular reason to make this a macro rather than a static inline?

Yes. As Eric Dumazet pointed out, hash_64() is slower than hash_32() so we should be calling hash_32() if possible (if key size is 32bits long).

This way we can call hash_min() without knowing the key size. See also the definition of hash_min() above.



