Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608Ab1GRSAb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 14:00:31 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:44029 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab1GRSA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 14:00:28 -0400
Date: Mon, 18 Jul 2011 10:58:21 -0700 (PDT)
Message-Id: <20110718.105821.1680531803712429890.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110718193053.623d28dc4643ab488b6347d5@canb.auug.org.au>
References: <20110718193053.623d28dc4643ab488b6347d5@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 18 Jul 2011 10:58:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 18 Jul 2011 19:30:53 +1000

> After merging the final tree, today's linux-next build (sparc64 defconfig)
> failed like this:
> 
> In file included from arch/sparc/include/asm/pgtable.h:4:0,
>                  from include/linux/mm.h:41,
>                  from include/linux/fs.h:395,
>                  from include/linux/compat.h:15,
>                  from arch/sparc/include/asm/siginfo.h:19,
>                  from include/linux/signal.h:5,
>                  from include/linux/sched.h:73,
>                  from arch/sparc/kernel/asm-offsets.c:13:
> arch/sparc/include/asm/pgtable_64.h: In function '__set_pte_at':
> arch/sparc/include/asm/pgtable_64.h:674:6: error: 'init_mm' undeclared (first use in this function)
> 
> I assume some include file changes.  Anyone have any clues how to find
> this?

The great irony is that sparc64 doesn't use anything this file
generates (you won't find a single asm-offsets.h include in any
sparc64 code).

This asm-offset mechanim is, for whatever reason, enabled on every
single architecture whether it's needed or not.  Maybe we should
rethink that.


