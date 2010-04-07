Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245Ab0DGDMX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 23:12:23 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55118
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753100Ab0DGDMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 23:12:17 -0400
Date: Tue, 06 Apr 2010 20:12:20 -0700 (PDT)
Message-Id: <20100406.201220.195404728.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, dm@chelsio.com, jpirko@redhat.com
Subject: Re: linux-next: build failure after merge of the net tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100407125817.e8e1d174.sfr@canb.auug.org.au>
References: <20100407125817.e8e1d174.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 7 Apr 2010 12:58:17 +1000

> After merging the wireless tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> drivers/net/cxgb4/cxgb4_main.c: In function 'set_addr_filters':
> drivers/net/cxgb4/cxgb4_main.c:264: error: dereferencing pointer to incomplete type
> drivers/net/cxgb4/cxgb4_main.c:265: error: dereferencing pointer to incomplete type
> 
> Caused by commit b8ff05a9c3237f694a1c3bf8ceec3bf6c3c14b15 ("cxgb4: Add
> main driver file and driver Makefile") from Linus' tree interacting with
> commit 22bedad3ce112d5ca1eaf043d4990fa2ed698c87 ("net: convert multicast
> list to list_head").  The latter removed struct dev_addr_list.
> 
> I have reverted commit b8ff05a9c3237f694a1c3bf8ceec3bf6c3c14b15 (and
> 43e9da8d782b8a40d5127fcc59ac2e543cf16d7d ("net: Hook up cxgb4 to Kconfig
> and Makefile") that depended on it) for today.

Thanks, I'll merge net-2.6 into net-next-2.6 and fix this build
failure in the latter.

