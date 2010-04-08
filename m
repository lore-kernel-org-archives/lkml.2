Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345Ab0DHGZA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 02:25:00 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36159
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751838Ab0DHGY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 02:24:57 -0400
Date: Wed, 07 Apr 2010 23:25:00 -0700 (PDT)
Message-Id: <20100407.232500.184442638.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, john.linn@xilinx.com, jtyner@cs.ucr.edu
Subject: Re: linux-next: build failure after merge of the final tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100408153505.eb205158.sfr@canb.auug.org.au>
References: <20100408153505.eb205158.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 8 Apr 2010 15:35:05 +1000

> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> drivers/net/ll_temac_main.c: In function 'll_temac_recv':
> drivers/net/ll_temac_main.c:695: error: implicit declaration of function 'virt_to_bus'
> 
> Caused by commit 459569145516f7967b916c57445feb02c600668c ("Add
> non-Virtex5 support for LL TEMAC driver") from the net tree.
> 
> I have reverted that commit for today.

And I'm reverting it too, it's illegal to use virt_to_bus()
in new code in this day and age.

John, you'll need to use the DMA mapping APIs in this change when you
resubmit it.

Thanks.
