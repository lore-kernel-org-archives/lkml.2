Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457Ab2BOVkL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 16:40:11 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:60975 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071Ab2BOVkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 16:40:08 -0500
Date: Wed, 15 Feb 2012 16:38:01 -0500 (EST)
Message-Id: <20120215.163801.2243433584488421039.davem@davemloft.net>
To: rdunlap@xenotime.net
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: linux-next: Tree for Feb 15 (decnet)
From: David Miller <davem@davemloft.net>
In-Reply-To: <4F3C0CE3.6020708@xenotime.net>
References: <20120215160352.60be31b78879628be7e446b8@canb.auug.org.au>
	<4F3C0CE3.6020708@xenotime.net>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 15 Feb 2012 13:38:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>
Date: Wed, 15 Feb 2012 11:52:03 -0800

> On 02/14/2012 09:03 PM, Stephen Rothwell wrote:
>> Hi all,
>> 
>> Changes since 20120214:
> 
> 
> on x86_64:
> 
>   CC      net/decnet/dn_nsp_in.o
> In file included from /next/linux-next-20120215/net/decnet/dn_nsp_in.c:75:0:
> /next/linux-next-20120215/include/net/dn.h:195:65: warning: 'struct flowidn' declared inside parameter list

I can't reproduce this in the net-next tree using your config but I can
certainly fix it, as follows :-)

--------------------
decnet: net/dn.h needs net/flow.h

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 include/net/dn.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/net/dn.h b/include/net/dn.h
index 298521e..814af0b 100644
--- a/include/net/dn.h
+++ b/include/net/dn.h
@@ -3,6 +3,7 @@
 
 #include <linux/dn.h>
 #include <net/sock.h>
+#include <net/flow.h>
 #include <asm/byteorder.h>
 #include <asm/unaligned.h>
 
-- 
1.7.7.6

