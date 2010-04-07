Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227Ab0DGRiZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 13:38:25 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:54901 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab0DGRiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 13:38:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=rzFtcdvceFmWlFGEwCe5IBn29l8fjkqpl0EJ1jNnOI0dgFvLFFnVwOM2XB3Bd/EJfA
         DIiTsFLHp4SvjqH9RflTJP/K1W1yI1GljEF/K+BNA/cpShVez3C5R6z0FyRMUxbTkbSA
         JNxfB9FZs9V2vzOKSgInmrrCg5CQUvPdsLY/o=
Subject: Re: linux-next: Tree for April 7 (net/core/dev_addr_lists)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>, David Miller <davem@davemloft.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, netdev <netdev@vger.kernel.org>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100407095845.f29ebf48.randy.dunlap@oracle.com>
References: <20100407174123.81b32310.sfr@canb.auug.org.au>
	 <20100407095845.f29ebf48.randy.dunlap@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Apr 2010 19:38:09 +0200
Message-ID: <1270661889.8141.45.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 07 avril 2010 à 09:58 -0700, Randy Dunlap a écrit :
> On Wed, 7 Apr 2010 17:41:23 +1000 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Changes since 20100401:
> 
> 
> when CONFIG_PROC_FS is disabled:
> 
> linux-next-20100407/net/core/dev_addr_lists.c: In function 'dev_mc_net_init':
> linux-next-20100407/net/core/dev_addr_lists.c:722: error: implicit declaration of function 'proc_net_fops_create'
> linux-next-20100407/net/core/dev_addr_lists.c:722: error: 'dev_mc_seq_fops' undeclared (first use in this function)
> linux-next-20100407/net/core/dev_addr_lists.c:722: error: (Each undeclared identifier is reported only once
> linux-next-20100407/net/core/dev_addr_lists.c:722: error: for each function it appears in.)
> linux-next-20100407/net/core/dev_addr_lists.c: In function 'dev_mc_net_exit':
> linux-next-20100407/net/core/dev_addr_lists.c:729: error: implicit declaration of function 'proc_net_remove'
> make[3]: *** [net/core/dev_addr_lists.o] Error 1
> 
> ---
> ~Randy

Thanks Randy, this should correct this

[PATCH net-next-2.6] net: include linux/proc_fs.h in dev_addr_lists.c

As pointed by Randy Dunlap, we must include linux/proc_fs.h in
net/core/dev_addr_lists.c, regardless of CONFIG_PROC_FS

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>, 
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
diff --git a/net/core/dev_addr_lists.c b/net/core/dev_addr_lists.c
index 37d5975..508f9c1 100644
--- a/net/core/dev_addr_lists.c
+++ b/net/core/dev_addr_lists.c
@@ -14,6 +14,7 @@
 #include <linux/netdevice.h>
 #include <linux/rtnetlink.h>
 #include <linux/list.h>
+#include <linux/proc_fs.h>
 
 /*
  * General list handling functions
@@ -667,7 +668,6 @@ void dev_mc_init(struct net_device *dev)
 EXPORT_SYMBOL(dev_mc_init);
 
 #ifdef CONFIG_PROC_FS
-#include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 
 static int dev_mc_seq_show(struct seq_file *seq, void *v)


