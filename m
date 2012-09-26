Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198Ab2IZO0i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 10:26:38 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47150 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755514Ab2IZO0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 10:26:36 -0400
Message-ID: <506310AA.2050700@gmail.com>
Date: Wed, 26 Sep 2012 16:26:50 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120913 Thunderbird/15.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: David Laight <David.Laight@ACULAB.COM>, torvalds@linux-foundation.org,
        tj@kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, mathieu.desnoyers@efficios.com, neilb@suse.de,
        bfields@fieldses.org, ejt@redhat.com, snitzer@redhat.com,
        edumazet@google.com, josh@joshtriplett.org, rmallon@gmail.com,
        palves@redhat.com
Subject: Re: [PATCH v6] hashtable: introduce a small and naive hashtable
References: <1348663729-2584-1-git-send-email-levinsasha928@gmail.com>  <AE90C24D6B3A694183C094C60CF0A2F6026B7008@saturn3.aculab.com> <1348667992.22822.50.camel@gandalf.local.home>
In-Reply-To: <1348667992.22822.50.camel@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2012 03:59 PM, Steven Rostedt wrote:
> On Wed, 2012-09-26 at 14:45 +0100, David Laight wrote:
>> Amazing how something simple gets lots of comments and versions :-)
>>
>>> ...
>>> + * This has to be a macro since HASH_BITS() will not work on pointers since
>>> + * it calculates the size during preprocessing.
>>> + */
>>> +#define hash_empty(hashtable)							\
>>> +({										\
>>> +	int __i;								\
>>> +	bool __ret = true;							\
>>> +										\
>>> +	for (__i = 0; __i < HASH_SIZE(hashtable); __i++)			\
>>> +		if (!hlist_empty(&hashtable[__i]))				\
>>> +			__ret = false;						\
>>> +										\
>>> +	__ret;									\
>>> +})
>>
>> Actually you could have a #define that calls a function
>> passing in the address and size.
> 
> Probably would be cleaner to do so.

I think it's worth it if it was more complex than a simple loop. We were doing a similar thing with the _size() functions (see
version 4 of this patch), but decided to remove it since it was becoming too complex.
> 
> 
>> Also, should the loop have a 'break' in it?
> 
> Yeah it should, and could do:
> 
> 	for (i = 0; i < HASH_SIZE(hashtable); i++)
> 		if (!hlist_empty(&hashtable[i]))
> 			break;
> 
> 	return i < HASH_SIZE(hashtable);

Right.


Thanks,
Sasha
