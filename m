Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055Ab0HaEnM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 00:43:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55206
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750913Ab0HaEnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 00:43:10 -0400
Date: Mon, 30 Aug 2010 21:43:27 -0700 (PDT)
Message-Id: <20100830.214327.57458877.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, akinobu.mita@gmail.com,
        fujita.tomonori@lab.ntt.co.jp
Subject: Re: linux-next: build failure after merge of the final tree (net
 tree related)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100831131812.1b8eb758.sfr@canb.auug.org.au>
References: <20100831131812.1b8eb758.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 31 Aug 2010 13:18:12 +1000

> Hi ,
> 
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> drivers/net/starfire.c: In function 'starfire_init':
> drivers/net/starfire.c:2081: error: negative width in bit-field '<anonymous>'
> 
> This is:
> 	BUILD_BUG_ON(sizeof(dma_addr_t) != sizeof(netdrv_addr_t));
> in starfire_init().
> 
> Immediate cause is commit 56543af9563d91c1c5596a7980b416389bdea071
> ("starfire: use BUILD_BUG_ON for netdrv_addr_t").

I anticipated this and Fujita is working on a solution involving
adding a CONFIG_DMA_ADDR_T_64BIT that the starfire can check
instead of that ugly CPP test.
