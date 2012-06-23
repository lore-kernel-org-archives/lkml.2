Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762842Ab2FWACk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 20:02:40 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38853 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378Ab2FWACi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 20:02:38 -0400
Date: Fri, 22 Jun 2012 17:02:37 -0700 (PDT)
Message-Id: <20120622.170237.1504103690155447356.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: johunt@akamai.com, kaber@trash.net, dbavatar@gmail.com,
        netdev@vger.kernel.org, yoshfuji@linux-ipv6.org, jmorris@namei.org,
        pekkas@netcore.fi, kuznet@ms2.inr.ac.ru, linux-kernel@vger.kernel.org
Subject: Re: Bug in net/ipv6/ip6_fib.c:fib6_dump_table()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1340388785.4604.11442.camel@edumazet-glaptop>
References: <1340353746.4604.9502.camel@edumazet-glaptop>
	<4FE476A6.1050209@akamai.com>
	<1340388785.4604.11442.camel@edumazet-glaptop>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Fri, 22 Jun 2012 20:13:05 +0200

> On Fri, 2012-06-22 at 08:44 -0500, Josh Hunt wrote:
> 
>> Ahh. That makes sense and is what Alexey said before I just didn't put
>> it all together. So we are OK reverting this patch? I cannot find a path
>> where the walker's pointers are updated without the tb6_lock write_lock.
>> 
> 
> There was a bug somewhere, not sure we want to NULL dereference again.

Well:

1) Patrick McHardy has been inactive for a while, so do not expect
   any insight from him.

2) Ben Greear isn't even on the CC: list of this discussion yet he
   appears to be the person who reproduced the crash way back then
   and is listed in the Tested-by tag of the commit.

   As a result we aren't likely to get any insight from the one person
   who actually could hit the crash.

I'm inclined to just revert simply because we have people active who
can reproduce regressions introduced by this change and nobody can
understand why the change is even necessary.
