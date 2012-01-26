Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab2AZShe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 13:37:34 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:33394 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab2AZShd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 13:37:33 -0500
Date: Thu, 26 Jan 2012 13:37:22 -0500 (EST)
Message-Id: <20120126.133722.1476758144256840158.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: sjur.brandeland@stericsson.com, levinsasha928@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, davej@redhat.com,
        sjurbren@gmail.com, ebiederm@xmission.com, xemul@openvz.org
Subject: Re: [PATCH] netns: fix net_alloc_generic()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1327574498.2500.22.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <CA+1xoqe+Qa1OByj7z7XzAPG_g9+BmNj9NPZR=_5b_MTEmc9Chw@mail.gmail.com>
	<1327523631-3480-1-git-send-email-sjur.brandeland@stericsson.com>
	<1327574498.2500.22.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 26 Jan 2012 10:37:25 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Thu, 26 Jan 2012 11:41:38 +0100

> [PATCH] netns: fix net_alloc_generic()
> 
> When a new net namespace is created, we should attach to it a "struct
> net_generic" with enough slots (even empty), or we can hit the following
> BUG_ON() :
> 
...
> net_alloc_generic() should take into account the maximum index into the
> ptr array, as a subsystem might use net_generic() anytime.
> 
> This also reduces number of reallocations in net_assign_generic()
> 
> Reported-by: Sasha Levin <levinsasha928@gmail.com>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Applied and queued up for -stable, thanks.
