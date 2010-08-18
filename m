Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751192Ab0HRCOK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 22:14:10 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35705
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750708Ab0HRCOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 22:14:05 -0400
Date: Tue, 17 Aug 2010 19:14:24 -0700 (PDT)
Message-Id: <20100817.191424.183031381.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, paulus@au.ibm.com,
        benh@kernel.crashing.org
Subject: Re: [GIT] Sparc
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTimZ3rhX2AzPExEGfRCXiFNN-BGOWRKqL241-qNa@mail.gmail.com>
References: <20100817.180325.104051399.davem@davemloft.net>
	<AANLkTikQ1dGw0aO10_ZwmVEc-JAVhB==3HS7SrWycE49@mail.gmail.com>
	<AANLkTimZ3rhX2AzPExEGfRCXiFNN-BGOWRKqL241-qNa@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 17 Aug 2010 18:59:17 -0700

> In commit 86fa04b8742ac681d470786f55e2403ada0075b2 you fix the return
> type, but you still have the wrong _argument_ type:
> 
>   extern void atomic64_add(int, atomic64_t *);
>   extern void atomic64_sub(int, atomic64_t *);
>   extern long atomic64_add_ret(int, atomic64_t *);
>   extern long atomic64_sub_ret(int, atomic64_t *);

Thanks, I'll fix that up.

> I merged your pull request, but you've got some fixing up to do,
> methinks. I also really think you need to make your rwsem's use 64-bit
> values on sparc64, because otherwise you can overflow the mmap_sem by
> having more than 65536 threads doing page-faults (on 32-bit, having
> more than 2**16 threads in one process is unlikely to work for other
> reasons, like just pure stack usage, so we don't really care about the
> 32-bit case)

I have a patch to do this already, just need to test it.

You should bug the powerpc folks too :-)
