Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758536Ab1BRUNu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 15:13:50 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48166
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758522Ab1BRUNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 15:13:48 -0500
Date: Fri, 18 Feb 2011 12:14:24 -0800 (PST)
Message-Id: <20110218.121424.112608933.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: torvalds@linux-foundation.org, ebiederm@xmission.com, opurdila@ixiacom.com,
        mingo@elte.hu, mhocko@suse.cz, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] net: dont leave active on stack LIST_HEAD
From: David Miller <davem@davemloft.net>
In-Reply-To: <1298019278.2595.83.camel@edumazet-laptop>
References: <1298010320.2642.7.camel@edumazet-laptop>
	<1298014191.2642.11.camel@edumazet-laptop>
	<1298019278.2595.83.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Fri, 18 Feb 2011 09:54:38 +0100

> From: Linus Torvalds <torvalds@linux-foundation.org>
> 
> Eric W. Biderman and Michal Hocko reported various memory corruptions
> that we suspected to be related to a LIST head located on stack, that
> was manipulated after thread left function frame (and eventually exited,
> so its stack was freed and reused).
> 
> Eric Dumazet suggested the problem was probably coming from commit
> 443457242beb (net: factorize
> sync-rcu call in unregister_netdevice_many)
> 
> This patch fixes __dev_close() and dev_close() to properly deinit their
> respective LIST_HEAD(single) before exiting.
> 
> References: https://lkml.org/lkml/2011/2/16/304
> References: https://lkml.org/lkml/2011/2/14/223
> 
> Reported-by: Michal Hocko <mhocko@suse.cz>
> Reported-by: Eric W. Biderman <ebiderman@xmission.com>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Applied.
