Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018Ab2G1R3W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2012 13:29:22 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:39013 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752900Ab2G1R3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2012 13:29:21 -0400
Message-ID: <1343496560.2009.15.camel@joe2Laptop>
Subject: Re: [PATCH] net: move "IPv6: sending pkt_too_big to self" to
 NETDEBUG
From: Joe Perches <joe@perches.com>
To: Philipp Kern <pkern@debian.org>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
        ak@linux.intel.com
Date: Sat, 28 Jul 2012 10:29:20 -0700
In-Reply-To: <1343487997-9047-1-git-send-email-pkern@debian.org>
References: <1343487997-9047-1-git-send-email-pkern@debian.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-07-28 at 17:06 +0200, Philipp Kern wrote:
> ip6_xmit checks if the outgoing packet is larger than the path MTU and
> emits ICMPv6 packet too big locally if this is the case. Logging this,
> even at KERN_DEBUG, confuses users. It is also not actually helpful for
> debugging, given that there is no reference to the connection that
> triggered this event.
[]
> diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
[]
> @@ -241,7 +241,7 @@ int ip6_xmit(struct sock *sk, struct sk_buff *skb, struct flowi6 *fl6,
>  			       dst->dev, dst_output);
>  	}
>  
> -	net_dbg_ratelimited("IPv6: sending pkt_too_big to self\n");
> +	LIMIT_NETDEBUG("IPv6: sending pkt_too_big to self\n");

LIMIT_NETDEBUG doesn't include a logging level.
Add a KERN_DEBUG prefix or another KERN_<LEVEL>.

Maybe it'd be better to add the context too.


