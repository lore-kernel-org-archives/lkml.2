Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759242Ab1EMNMY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 09:12:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49531 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758584Ab1EMNMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 09:12:23 -0400
Date: Fri, 13 May 2011 15:12:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL rcu/next] rcu commits for 2.6.40
Message-ID: <20110513131218.GA7669@elte.hu>
References: <4DCB157F.20202@kernel.org>
 <20110512060344.GB3191@elte.hu>
 <4DCB8BCD.1080607@kernel.org>
 <4DCB8F7A.90603@kernel.org>
 <20110512092013.GJ2258@linux.vnet.ibm.com>
 <4DCC52FB.6030500@kernel.org>
 <4DCC894D.3070204@kernel.org>
 <20110513084253.GE13647@elte.hu>
 <20110513121906.GA3676@elte.hu>
 <20110513130414.GA6863@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110513130414.GA6863@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> I started bisecting this, and the two relevant endpoints:
> 
>   bad: 11c476f: net,rcu: convert call_rcu(prl_entry_destroy_rcu) to kfree
>  good: 0ee5623f: Linux 2.6.39-rc6
> 
> very clearly indicate that this is an RCU regression.

This might be the same one Yinghai found:

 e59fb3120bec: rcu: Decrease memory-barrier usage based on semi-formal proof

So with the config i sent it's definitely reproducible.

At first sight couldnt this be related not to barriers, but to not setting 
need_resched() like we did before?

Thanks,

	Ingo
