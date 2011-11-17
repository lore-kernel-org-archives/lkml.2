Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab1KQVf1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 16:35:27 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:46212 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585Ab1KQVfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 16:35:25 -0500
Date: Thu, 17 Nov 2011 16:35:01 -0500 (EST)
Message-Id: <20111117.163501.1963137869848419475.davem@davemloft.net>
To: jbottomley@parallels.com
Cc: eric.dumazet@gmail.com, glommer@parallels.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        paul@paulmenage.org, lizf@cn.fujitsu.com, linux-mm@kvack.org,
        devel@openvz.org, kirill@shutemov.name, gthelen@google.com,
        kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [Devel] Re: [PATCH v5 00/10] per-cgroup tcp memory pressure
From: David Miller <davem@davemloft.net>
In-Reply-To: <1321381632.3021.57.camel@dabdike.int.hansenpartnership.com>
References: <1320679595-21074-1-git-send-email-glommer@parallels.com>
	<4EBAC04F.1010901@parallels.com>
	<1321381632.3021.57.camel@dabdike.int.hansenpartnership.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 17 Nov 2011 13:35:05 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Bottomley <jbottomley@parallels.com>
Date: Tue, 15 Nov 2011 18:27:12 +0000

> Ping on this, please.  We're blocked on this patch set until we can get
> an ack that the approach is acceptable to network people.

__sk_mem_schedule is now more expensive, because instead of short-circuiting
the majority of the function's logic when "allocated <= prot->sysctl_mem[0]"
and immediately returning 1, the whole rest of the function is run.

The static branch protecting all of the cgroup code seems to be
enabled if any memory based cgroup'ing is enabled.  What if people use
the memory cgroup facility but not for sockets?  I am to understand
that, of the very few people who are going to use this stuff in any
capacity, this would be a common usage.

TCP specific stuff in mm/memcontrol.c, at best that's not nice at all.

Otherwise looks mostly good.
