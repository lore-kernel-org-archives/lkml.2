Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585Ab2HJEFv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 00:05:51 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:36475 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab2HJEFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 00:05:48 -0400
Date: Thu, 09 Aug 2012 21:05:46 -0700 (PDT)
Message-Id: <20120809.210546.819623704116134361.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: eparis@parisplace.org, paul@paul-moore.com, casey@schaufler-ca.com,
        johnstul@us.ibm.com, serge@hallyn.com, linux-kernel@vger.kernel.org,
        james.l.morris@oracle.com, selinux@tycho.nsa.gov,
        john.johansen@canonical.com, linux-security-module@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] ipv4: tcp: unicast_sock should not land outside of TCP
 stack
From: David Miller <davem@davemloft.net>
In-Reply-To: <1344556566.31104.808.camel@edumazet-glaptop>
References: <1344547743.31104.582.camel@edumazet-glaptop>
	<20120809.163851.1182547052663187702.davem@davemloft.net>
	<1344556566.31104.808.camel@edumazet-glaptop>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Fri, 10 Aug 2012 01:56:06 +0200

> From: Eric Dumazet <edumazet@google.com>
> 
> commit be9f4a44e7d41cee (ipv4: tcp: remove per net tcp_sock) added a
> selinux regression, reported and bisected by John Stultz
> 
> selinux_ip_postroute_compat() expect to find a valid sk->sk_security
> pointer, but this field is NULL for unicast_sock
> 
> It turns out that unicast_sock are really temporary stuff to be able
> to reuse  part of IP stack (ip_append_data()/ip_push_pending_frames())
> 
> Fact is that frames sent by ip_send_unicast_reply() should be orphaned
> to not fool LSM.
> 
> Note IPv6 never had this problem, as tcp_v6_send_response() doesnt use a
> fake socket at all. I'll probably implement tcp_v4_send_response() to
> remove these unicast_sock in linux-3.7
> 
> Reported-by: John Stultz <johnstul@us.ibm.com>
> Bisected-by: John Stultz <johnstul@us.ibm.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied.
