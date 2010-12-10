Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274Ab0LJWBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 17:01:20 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42032
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756034Ab0LJWBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 17:01:19 -0500
Date: Fri, 10 Dec 2010 14:01:46 -0800 (PST)
Message-Id: <20101210.140146.68123509.davem@davemloft.net>
To: pablo@netfilter.org
Cc: netfilter-devel@lists.netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: ctnetlink loop
From: David Miller <davem@davemloft.net>
In-Reply-To: <4D00B5CD.3050406@netfilter.org>
References: <20101203133903.GG13225@mail.eitzenberger.org>
	<4D00B5CD.3050406@netfilter.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Thu, 09 Dec 2010 11:56:13 +0100

> netfilter: ctnetlink: fix loop in ctnetlink_get_conntrack()
> 
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> This patch fixes a loop in ctnetlink_get_conntrack() that can be
> triggered if you use the same socket to receive events and to
> perform a GET operation. Under heavy load, netlink_unicast()
> may return -EAGAIN, this error code is reserved in nfnetlink for
> the module load-on-demand. Instead, we return -ENOBUFS which is
> the appropriate error code that has to be propagated to
> user-space.
> 
> Reported-by: Holger Eitzenberger <holger@eitzenberger.org>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Since Patrick seems to be inactive I have applied this directly
to net-2.6, thanks guys!
