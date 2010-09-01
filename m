Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab0IAVqn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 17:46:43 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48096
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752080Ab0IAVql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 17:46:41 -0400
Date: Wed, 01 Sep 2010 14:46:58 -0700 (PDT)
Message-Id: <20100901.144658.135972233.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: bandan.das@stratus.com, herbert@gondor.hengli.com.au,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kaber@trash.net
Subject: Re: [PATCH net-next-2.6] net/ipv4: push IP options to CB in
 ip_fragment
From: David Miller <davem@davemloft.net>
In-Reply-To: <1283232031.2405.38.camel@edumazet-laptop>
References: <1283204118.2405.32.camel@edumazet-laptop>
	<20100830232147.GB10754@stratus.com>
	<1283232031.2405.38.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Tue, 31 Aug 2010 07:20:31 +0200

> We could have a padding in front of struct br_input_skb_cb to make sure
> we dont overwrite IP (4|6) CB in bridge ?
> 
> Something like this untested patch :

This will not help Brandan's case.

His packets are coming straight from TUN/TAP.  They did not live in
the IP stack at all before hitting the bridge and then heading to
ip_fragment().

Therefore I'm inclined to agree with Herbert that we need to parse the
options explicitly before invoke ip_fragment().  We must call it with
an SKB in the state it expects, and that means with options parsing
already performed.


