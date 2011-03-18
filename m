Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259Ab1CRBNA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 21:13:00 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33086
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755787Ab1CRBM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 21:12:58 -0400
Date: Thu, 17 Mar 2011 18:13:36 -0700 (PDT)
Message-Id: <20110317.181336.226775410.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: roland@kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, hal.rosenstock@gmail.com,
        eric.dumazet@gmail.com, tj@kernel.org, xiaosuo@gmail.com,
        linux-rdma@vger.kernel.org
Subject: Re: linux-next: build warning in Linus' tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110318100418.6556c92c.sfr@canb.auug.org.au>
References: <20110318100418.6556c92c.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 18 Mar 2011 10:04:18 +1100

> Hi all,
> 
> After merging the Linus' tree, today's linux-next build (powerpc
> ppc64_defconfig) produced this warning:
> 
> drivers/infiniband/core/addr.c: In function 'addr4_resolve':
> drivers/infiniband/core/addr.c:188: warning: 'ret' may be used uninitialized in this function
> 
> I didn't notice this one before, sorry.
> 
> I don't know what introduced it, but the third if statement in the
> function will make us use "ret" uninitialised.

It was the ipv4 route lookup interface changes.

Roland has received a fix already, and will merge it via the infiniband
tree.
