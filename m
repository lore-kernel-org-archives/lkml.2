Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759242Ab1LORCk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 12:02:40 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:42347 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759172Ab1LORCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 12:02:39 -0500
Date: Thu, 15 Dec 2011 12:00:28 -0500 (EST)
Message-Id: <20111215.120028.532844419499092747.davem@davemloft.net>
To: glommer@parallels.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        eric.dumazet@gmail.com, sfr@canb.auug.org.au
Subject: Re: [PATCH 2/2] Explicitly call tcp creation and init from
 memcontrol.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <1323941672-14324-3-git-send-email-glommer@parallels.com>
References: <1323941672-14324-1-git-send-email-glommer@parallels.com>
	<1323941672-14324-3-git-send-email-glommer@parallels.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 15 Dec 2011 09:00:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <glommer@parallels.com>
Date: Thu, 15 Dec 2011 13:34:32 +0400

> Walking the proto_list holds a read_lock, which prevents us from doing
> allocations. Splitting the tcp create function into create + init is
> good, but it is not enough since create_files will do allocations as well
> (dentry ones, mostly).
> 
> Since this does not involve any protocol state, I propose we call the tcp
> functions explicitly from memcontrol.c
> 
> With this, we lose by now the ability of doing cgroup memcontrol for
> protocols that are loaded as modules. But at least the ones I have in mind
> won't really need it (tcp_ipv6 being the only one, but it uses the same data
> structures as tcp_ipv4). So I believe this to be the simpler solution to this
> problem.
> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>

This is an unnecessary limitation, please fix this properly otherwise
DCCP, SCTP, etc. won't be supportable with this stuff.
