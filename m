Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092Ab1I1Sed (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 14:34:33 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:43279 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755030Ab1I1Seb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 14:34:31 -0400
Date: Wed, 28 Sep 2011 14:32:13 -0400 (EDT)
Message-Id: <20110928.143213.1468578830673905204.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: jasowang@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@suse.de, stable@kernel.org, mst@redhat.com, akong@redhat.com
Subject: Re: Possible NULL dereference caused by -stable commit
 ef81bb40bf15f350fe865f31fa42f1082772a576
From: David Miller <davem@davemloft.net>
In-Reply-To: <1317211749.2941.6.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <4E82FC4E.5010101@redhat.com>
	<1317211749.2941.6.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 28 Sep 2011 11:32:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 28 Sep 2011 14:09:09 +0200

> 1) Discussion on current kernel :
> 
> All we need here is not the route but inet_peer, so that inet_getid()
> can be called on it.
> 
> If no route is given to ipv6_select_ident(), at least we can try to get
> inet_peer, and release it before exiting from ipv6_select_ident()

Ok, after some auditing, there is only one call site of ipv6_select_ident()
that can happen with a NULL route and that is udp6_ufo_fragment().

ipv6_gso_segment() already walks the extension headers via
ipv6_gso_pull_exthdrs() so maybe we can calculate the true destination
address there and get that passed down somehow into the fragment ID
selection for an inetpeer lookup.
