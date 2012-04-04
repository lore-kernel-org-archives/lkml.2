Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021Ab2DDJ3A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 05:29:00 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:43789 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594Ab2DDJ27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 05:28:59 -0400
Date: Wed, 04 Apr 2012 05:26:17 -0400 (EDT)
Message-Id: <20120404.052617.987975279373275914.davem@davemloft.net>
To: shmulik.ladkani@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net
Subject: Re: [PATCH] ipv6: Fix 'inet6_rtm_getroute' to release 'rt->dst' in
 case of 'alloc_skb' failure
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120404121300.2e05437b@pixies.home.jungo.com>
References: <20120404121300.2e05437b@pixies.home.jungo.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 04 Apr 2012 02:26:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Date: Wed, 4 Apr 2012 12:13:00 +0300

> In 72331bc [ipv6: Fix RTM_GETROUTE's interpretation of RTA_IIF to be
> consistent with ipv4] the code of 'inet6_rtm_getroute()' was re-ordered
> such that the reference to 'rt->dst' is incremented prior skb
> allocation.
> 
> Hence, if 'alloc_skb()' fails, must drop a reference from 'rt->dst'.
> Add the missing 'dst_release()' call.
> 
> Signed-off-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>

Applied, thanks.
