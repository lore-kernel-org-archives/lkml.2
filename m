Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758194Ab2EHC7Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 22:59:24 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:53827 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758088Ab2EHC7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 22:59:23 -0400
Date: Mon, 07 May 2012 22:56:31 -0400 (EDT)
Message-Id: <20120507.225631.1240115443298845028.davem@davemloft.net>
To: eldad@fogrefinery.com
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, eric.dumazet@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] [IPV6] remove sysctl accept_source_route
From: David Miller <davem@davemloft.net>
In-Reply-To: <1335695830-19176-1-git-send-email-eldad@fogrefinery.com>
References: <1335695830-19176-1-git-send-email-eldad@fogrefinery.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 07 May 2012 19:56:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eldad Zack <eldad@fogrefinery.com>
Date: Sun, 29 Apr 2012 12:37:10 +0200

> The only place where the accpet_source_route flag is checked is when we
> are processing the type 2 routing header. In that case we only allow it if
> it (1) has only segments left = 1 and (2) if it matches our home address,
> which is the behavior required by RFC 6275 (see sections 8.5, 11.3.3), and
> it doesn't make sense to block rh2 when we're a mobile node.
> 
> Signed-off-by: Eldad Zack <eldad@fogrefinery.com>

Considering commits:

commit c382bb9d32a55029fb13b118858e25908fab4617
Author: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Date:   Tue Jul 10 22:47:58 2007 -0700

    [IPV6]: Restore semantics of Routing Header processing.
    
    The "fix" for emerging security threat was overkill and it broke
    basic semantic of IPv6 routing header processing.  We should assume
    RT0 (or even RT2, depends on configuration) as "unknown" RH type so
    that we
    - silently ignore the routing header if segleft == 0
    - send ICMPv6 Parameter Problem message back to the sender,
      otherwise.
    
    Signed-off-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
    Signed-off-by: David S. Miller <davem@davemloft.net>

and:

commit bb4dbf9e61d0801927e7df2569bb3dd8287ea301
Author: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Date:   Tue Jul 10 22:55:49 2007 -0700

    [IPV6]: Do not send RH0 anymore.
    
    Based on <draft-ietf-ipv6-deprecate-rh0-00.txt>.
    
    Signed-off-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
    Signed-off-by: David S. Miller <davem@davemloft.net>

the current behavior seems very much intentional.

Secondly, we cannot just delete sysctls like this, if someone
depends upon whatever current behavior is we will break them.

Therefore, on either account, I cannot apply this patch.

Sorry.
