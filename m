Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517Ab1JSICz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 04:02:55 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:57901 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486Ab1JSICu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 04:02:50 -0400
Date: Wed, 19 Oct 2011 04:02:40 -0400 (EDT)
Message-Id: <20111019.040240.758852119107748001.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: herbert@gondor.hengli.com.au, evonlanthen@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        timo.teras@iki.fi
Subject: Re: PROBLEM: System call 'sendmsg' of process ospfd (quagga)
 causes kernel oops
From: David Miller <davem@davemloft.net>
In-Reply-To: <1319010739.18562.6.camel@edumazet-laptop>
References: <1319008713.17914.8.camel@edumazet-laptop>
	<20111019.033052.851679720607111734.davem@davemloft.net>
	<1319010739.18562.6.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 19 Oct 2011 01:02:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 19 Oct 2011 09:52:19 +0200

> For GRE tunnels, I dont think IPv6 fragmentation could be relevant,
> but maybe IGMP could trigger a problem ?

Funny... icmpv6 uses ip6_append_data() which uses hh_len in a
local variable, which seems to suggest that it's immune to
this problem.

IPV4 side seems identical in this regard.

So, as far as I can see, my patch is sufficient to cover IP_GRE
reasonably in the 'net' tree.

Agreed?

If so, someone please test this thing :-)
