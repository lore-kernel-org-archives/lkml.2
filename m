Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab2HASTY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 14:19:24 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55395 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289Ab2HASTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 14:19:22 -0400
Message-ID: <50197348.9010101@gmail.com>
Date: Wed, 01 Aug 2012 20:19:52 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120730 Thunderbird/14.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        paul.gortmaker@windriver.com
Subject: Re: [RFC 1/4] hashtable: introduce a small and naive hashtable
References: <1343757920-19713-1-git-send-email-levinsasha928@gmail.com> <1343757920-19713-2-git-send-email-levinsasha928@gmail.com> <20120731182330.GD21292@google.com>
In-Reply-To: <20120731182330.GD21292@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2012 08:23 PM, Tejun Heo wrote:
> Hello, Sasha.
> 
> On Tue, Jul 31, 2012 at 08:05:17PM +0200, Sasha Levin wrote:
>> +#define HASH_INIT(name)							\
>> +({									\
>> +	int __i;							\
>> +	for (__i = 0 ; __i < HASH_SIZE(name) ; __i++)			\
>> +		INIT_HLIST_HEAD(&name[__i]);				\
>> +})
> 
> Why use macro?
> 
>> +#define HASH_ADD(name, obj, key)					\
>> +	hlist_add_head(obj, &name[					\
>> +		hash_long((unsigned long)key, HASH_BITS(name))]);
> 
> Ditto.

Oh, yes, I've started working on this and remembered why it's macro in the first place.

Notice that we don't store hashtable size anywhere, this is because we can get it directly from the size of the hashtable array itself.

If we switch to using functions, we could no longer hide it anywhere (we'd need to either turn the buckets into a struct, or have the user pass it around to all functions).
