Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab2H3RFa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 13:05:30 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37865 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544Ab2H3RF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 13:05:28 -0400
Date: Thu, 30 Aug 2012 13:05:26 -0400 (EDT)
Message-Id: <20120830.130526.863740770089967659.davem@davemloft.net>
To: decot@googlers.com
Cc: aabdulla@nvidia.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        edumazet@google.com, joe@perches.com
Subject: Re: [PATCH net-next v1 0/3] forcedeth: fix device lock-up for
 dual-port NICs
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1345864542.git.decot@googlers.com>
References: <cover.1345864542.git.decot@googlers.com>
X-Mailer: Mew version 6.5 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Decotigny <decot@googlers.com>
Date: Fri, 24 Aug 2012 20:22:50 -0700

> On a dual port MCP55 10de:0373 (rev a3) NIC with both ports connected,
> we identified a configuration that does freeze the whole NIC: having
> autoneg & TX pause turned on while one port is physically connected
> but interface is down (eg. eth1) eventually causes the whole NIC to
> freeze (eth1 and... eth0). This triggers TX timeouts on the UP
> interface and, more generally, an unreachable network.
> 
> In order to avoid the bug, all we have to do is make sure not to
> configure TX pause on the hardware while NIC is down. This is what the
> 2nd patch of the series does (details included).
> 
> And, in case the NIC is in a bad state at reboot (should not happen
> anymore thanks to patch above), third patch basically always makes
> sure to fix the NIC when module is loaded.
> 
> I could only test this with a MCP55 10de:0373 (rev a3) PCI device on a
> x86_64 host.

All applied to net-next, thanks.
