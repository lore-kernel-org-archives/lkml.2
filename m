Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757677Ab2IJMSa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 08:18:30 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43770 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757286Ab2IJMS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 08:18:29 -0400
Message-ID: <504DDAAB.7090001@gmail.com>
Date: Mon, 10 Sep 2012 14:18:51 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120902 Thunderbird/15.0
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: torvalds@linux-foundation.org, tj@kernel.org, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, ebiederm@xmission.com, josh@joshtriplett.org,
        David.Laight@ACULAB.COM, palves@redhat.com, rmallon@gmail.com,
        bfields@fieldses.org
Subject: Re: [PATCH v4] hashtable: introduce a small and naive hashtable
References: <1347195123-5210-1-git-send-email-levinsasha928@gmail.com> <20120910024813.GA32008@Krystal>
In-Reply-To: <20120910024813.GA32008@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2012 04:48 AM, Mathieu Desnoyers wrote:
> * Sasha Levin (levinsasha928@gmail.com) wrote:
>> +#define hash_init(hashtable)							\
>> +({										\
>> +	int __i;								\
>> +										\
>> +	for (__i = 0; __i < HASH_BITS(hashtable); __i++)			\
>> +		INIT_HLIST_HEAD(hashtable + __i);				\
> 
> I suspect that hashtable will be a pointer, and you use the "+" operator
> to do an offset on this pointer. Any thought on using:
> 
>             INIT_HLIST_HEAD(&hashtable[__i]);
> 
> instead ? It would provide the same result, but would ensure that the
> user is indeed passing a pointer, and not an integer.

It also looks nicer :)

> Also, why isn't it a static inline ? I'm probably missing something. If
> there is a reason why it needs to stay a #define, please document it in
> the comment.

It's a define because it needs to get the size of the hashtable.

I'll document that.


Thanks,
Sasha
