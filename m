Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370Ab1DHMZ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 08:25:28 -0400
Received: from gmmr7.centrum.cz ([90.183.38.150]:57288 "EHLO gmmr7.centrum.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756239Ab1DHMZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 08:25:24 -0400
To: "Changli Gao" <xiaosuo@gmail.com>, "Eric Dumazet" <eric.dumazet@gmail.com>
Subject: Re: Regression from 2.6.36
Date: Fri, 08 Apr 2011 14:25:21 +0200
From: "azurIt" <azurit@pobox.sk>
Cc: "=?UTF-8?Q?Am=C3=A9rico=20Wang?=" <xiyou.wangcong@gmail.com>,
        "Jiri Slaby" <jslaby@suse.cz>, <linux-kernel@vger.kernel.org>,
        "Andrew Morton" <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
        <linux-fsdevel@vger.kernel.org>, "Jiri Slaby" <jirislaby@gmail.com>
References: <20110315132527.130FB80018F1@mail1005.cent> <20110317001519.GB18911@kroah.com> <20110407120112.E08DCA03@pobox.sk> <4D9D8FAA.9080405@suse.cz> <BANLkTinnTnjZvQ9S1AmudZcZBokMy8-93w@mail.gmail.com> <1302177428.3357.25.camel@edumazet-laptop> <1302178426.3357.34.camel@edumazet-laptop> <BANLkTikxWy-Pw1PrcAJMHs2R7JKksyQzMQ@mail.gmail.com>
In-Reply-To: <BANLkTikxWy-Pw1PrcAJMHs2R7JKksyQzMQ@mail.gmail.com>
X-Mailer: Centrum Email 5.3
X-Priority: 3
MIME-Version: 1.0
Message-Id: <20110408142521.4C13197E@pobox.sk>
X-Maser: brud
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>azurlt, would you please test the patch attached? Thanks.

This patch fixed the problem, i used 2.6.36.4 for testing. Do you need from me to test also other kernel versions or patches ?

Thank you very much!


______________________________________________________________
> Od: "Changli Gao" <xiaosuo@gmail.com>
> Komu: Eric Dumazet <eric.dumazet@gmail.com>
> Dátum: 07.04.2011 17:27
> Predmet: Re: Regression from 2.6.36
>
> CC: "Américo Wang" <xiyou.wangcong@gmail.com>, "Jiri Slaby" <jslaby@suse.cz>, linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, "Jiri Slaby" <jirislaby@gmail.com>
>On Thu, Apr 7, 2011 at 8:13 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>> Le jeudi 07 avril 2011 à 13:57 +0200, Eric Dumazet a écrit :
>>
>>> We had a similar memory problem in fib_trie in the past  : We force a
>>> synchronize_rcu() every XXX Mbytes allocated to make sure we dont have
>>> too much ram waiting to be freed in rcu queues.
>
>I don't think there is too much memory allocated by vmalloc to free.
>My patch should reduce the size of the memory allocated by vmalloc().
>I think the real problem is kfree always returns the memory, whose
>size is aligned to 2^n pages, and more memory are used than before.
>
>>
>> This was done in commit c3059477fce2d956
>> (ipv4: Use synchronize_rcu() during trie_rebalance())
>>
>> It was possible in fib_trie because we hold RTNL lock, so managing
>> a counter was free.
>>
>> In fs case, we might use a percpu_counter if we really want to limit the
>> amount of space.
>>
>> Now, I am not even sure we should care that much and could just forget
>> about this high order pages use.
>
>In normal cases, only a few fds are used, the ftable isn't larger than
>one page, so we should use kmalloc to reduce the memory cost. Maybe we
>should set a upper limit for kmalloc() here. One page?
>
>
>-- 
>Regards,
>Changli Gao(xiaosuo@gmail.com)
>
>
