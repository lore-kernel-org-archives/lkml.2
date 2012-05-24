Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537Ab2EXE1f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 00:27:35 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:36534 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727Ab2EXE1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 00:27:32 -0400
Date: Thu, 24 May 2012 00:27:29 -0400 (EDT)
Message-Id: <20120524.002729.1984174187865627892.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: kunx.jiang@intel.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yanmin_zhang@linux.intel.com
Subject: Re: [PATCH V2] ipv4: fix the rcu race between free_fib_info and
 ip_route_output_slow
From: David Miller <davem@davemloft.net>
In-Reply-To: <1337827362.3361.3800.camel@edumazet-glaptop>
References: <4FBD9161.3040206@intel.com>
	<1337827362.3361.3800.camel@edumazet-glaptop>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 23 May 2012 21:27:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Thu, 24 May 2012 04:42:42 +0200

> On Thu, 2012-05-24 at 09:39 +0800, kun.jiang wrote:
>> From: Yanmin Zhang <yanmin_zhang@linux.intel.com>
>> 
>> We hit a kernel OOPS.
>> 
> ...
>> 
>> Function free_fib_info resets nexthop_nh->nh_dev to NULL before releasing
>> fi. Other cpu might be accessing fi. Fixing it by delaying the releasing.
>> 
>> With the patch, we ran MTBF testing on Android mobile for 12 hours
>> and didn't trigger the issue.
>> 
>> Thank Eric for very detailed review/checking the issue.
>> 
>> Signed-off-by: Yanmin Zhang <yanmin_zhang@linux.intel.com>
>> Signed-off-by: Kun Jiang <kunx.jiang@intel.com>
>> ---
>>  net/ipv4/fib_semantics.c |   12 ++++++------
>>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> Acked-by: Eric Dumazet <edumazet@google.com>

Applied, thanks everyone.
