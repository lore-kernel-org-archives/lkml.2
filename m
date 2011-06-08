Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab1FHHSW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 03:18:22 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:38412 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839Ab1FHHSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 03:18:21 -0400
Date: Wed, 08 Jun 2011 00:16:12 -0700 (PDT)
Message-Id: <20110608.001612.225121497206099693.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, adobriyan@gmail.com
Subject: Re: linux-next: build failure after merge of the final tree (net
 tree related)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110608155411.c3a2aa09.sfr@canb.auug.org.au>
References: <20110608155411.c3a2aa09.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 08 Jun 2011 00:16:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 8 Jun 2011 15:54:11 +1000

> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> drivers/net/ll_temac_main.c: In function 'temac_open':
> drivers/net/ll_temac_main.c:859:2: error: implicit declaration of function 'request_irq'
> drivers/net/ll_temac_main.c:870:2: error: implicit declaration of function 'free_irq'
> drivers/net/ll_temac_main.c: In function 'temac_poll_controller':
> drivers/net/ll_temac_main.c:903:2: error: implicit declaration of function 'disable_irq'
> drivers/net/ll_temac_main.c:909:2: error: implicit declaration of function 'enable_irq'

Oh well, I hit all the drivers I could with x86 and sparc64 builds.

> Probably caused by commit a6b7a407865a ("net: remove interrupt.h
> inclusion from netdevice.h").
> 
> I have added this patch for today:
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Wed, 8 Jun 2011 15:49:33 +1000
> Subject: [PATCH] net: add needed interrupt.h

Applied, thanks Stephen.
