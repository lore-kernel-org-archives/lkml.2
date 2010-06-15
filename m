Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757211Ab0FOCNq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 22:13:46 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45566
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755741Ab0FOCNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 22:13:45 -0400
Date: Mon, 14 Jun 2010 19:13:56 -0700 (PDT)
Message-Id: <20100614.191356.193722104.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, andy@greyhouse.net,
       emil.s.tantilov@intel.com, jeffrey.t.kirsher@intel.com
Subject: Re: linux-next: build failure after merge of the net tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100615120052.7202f20d.sfr@canb.auug.org.au>
References: <20100615120052.7202f20d.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 15 Jun 2010 12:00:52 +1000

> Hi Dave,
> 
> After merging the wireless tree, today's linux-next build (powerpc ppc64_defconfig)
> failed like this:
> 
> drivers/net/ixgbe/ixgbe_ethtool.c: In function 'ixgbe_set_flags':
> drivers/net/ixgbe/ixgbe_ethtool.c:2232: error: implicit declaration of function 'DPRINTK'
> drivers/net/ixgbe/ixgbe_ethtool.c:2232: error: 'PROBE' undeclared (first use in this function)
> drivers/net/ixgbe/ixgbe_ethtool.c:2232: error: 'INFO' undeclared (first use in this function)
> 
> Commit 28c8e4790ca5ef75f54895ca46437f9fbb433ddf ("ixgbe: fix automatic
> LRO/RSC settings for low latency") from the net-current tree added
> another use of DPRINTK which needs comverting to e_info().  I applied the
> following patch:
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 15 Jun 2010 11:43:33 +1000
> Subject: [PATCH] net: ixgbe_ethtool merge fix up
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

I'll incorporate your merge and build fixups when I merge net-2.6 into
net-next-2.6 later tonight, thanks Stephen!
