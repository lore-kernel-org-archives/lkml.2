Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543Ab2BAHLR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 02:11:17 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:56238 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044Ab2BAHLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 02:11:15 -0500
Date: Wed, 01 Feb 2012 02:10:02 -0500 (EST)
Message-Id: <20120201.021002.1399660597996401402.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: lizf@cn.fujitsu.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, nhorman@tuxdriver.com
Subject: Re: [PATCH 6/6] cls_cgroup: remove redundant rcu_read_lock/unlock
From: David Miller <davem@davemloft.net>
In-Reply-To: <1328080039.22641.2.camel@edumazet-laptop>
References: <4F28E1D1.900@cn.fujitsu.com>
	<4F28E22A.703@cn.fujitsu.com>
	<1328080039.22641.2.camel@edumazet-laptop>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 31 Jan 2012 23:10:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 01 Feb 2012 08:07:19 +0100

> Then, I wonder why we do the "if (classid && classid != sk->sk_classid)"
> 
> before the :
> 
> 	sk->sk_classid = classid;
> 
> This seems unnecessary checks.
> 

Avoiding dirtying the sk->sk_classid cache line unnecessarily?

I actually have no idea actually how often this routine can get
invoked in real world scenerios.
