Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712Ab0GIRxS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 13:53:18 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48284
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752749Ab0GIRxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 13:53:16 -0400
Date: Fri, 09 Jul 2010 10:53:30 -0700 (PDT)
Message-Id: <20100709.105330.104045737.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: felipewd@gmail.com, kaber@trash.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] tproxy: nf_tproxy_assign_sock() can handle tw sockets
From: David Miller <davem@davemloft.net>
In-Reply-To: <1278695580.2696.55.camel@edumazet-laptop>
References: <1278626921.2435.73.camel@edumazet-laptop>
	<AANLkTiliBClahTfb41M5BDi1etg5pgkqEz_VfGrn_mK4@mail.gmail.com>
	<1278695580.2696.55.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Fri, 09 Jul 2010 19:13:00 +0200

> Reviewing tproxy stuff I spotted a problem in nf_tproxy_assign_sock()
> but I could not see how it could explain your crash.
> 
> We can read uninitialized memory and trigger a fault in
> nf_tproxy_assign_sock(), not later in tcp_recvmsg()...
> 
> David, Patrick, what do you think ?
> 
> Thanks
> 
> [PATCH] tproxy: nf_tproxy_assign_sock() can handle tw sockets
> 
> transparent field of a socket is either inet_twsk(sk)->tw_transparent
> for timewait sockets, or inet_sk(sk)->transparent for other sockets
> (TCP/UDP).
> 
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Looks fine to me:

Acked-by: David S. Miller <davem@davemloft.net>
