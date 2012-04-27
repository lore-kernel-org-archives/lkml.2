Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761249Ab2D0S7E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 14:59:04 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:42015 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760475Ab2D0S7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 14:59:00 -0400
Subject: Re: [PATCH RFC 1/2] netfilter: conntrack: remove RCU usage in
 conntrack notifier
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Benjamin Poirier <bpoirier@suse.de>
Cc: netdev@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Frysinger <vapier@gentoo.org>, Arun Sharma <asharma@fb.com>,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1335551333-6103-1-git-send-email-bpoirier@suse.de>
References: <1335551333-6103-1-git-send-email-bpoirier@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 Apr 2012 20:58:51 +0200
Message-ID: <1335553131.2775.252.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-27 at 14:28 -0400, Benjamin Poirier wrote:
> I think that the rcu usage in this code is pointless. It should either be
> removed or, if it was intended to protect against something, it ought to make
> that clear.
> 
> 1) The code does not make use of the deferred deletion/wait for completion rcu
> api (ie. synchronize_rcu(), call_rcu()).
> 2) It does not benefit from the barriers implied by the rcu primitives used.
> The code deals with callback pointers. There's no need to order writes to the
> function code (!) before writes to the function pointers here.
> ---

At a first glance, this seems pretty wrong.

code can disappear under you, thats for sure.

CONFIG_NF_CT_NETLINK=m

hint : module unload contains an rcu barrier.



