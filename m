Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab0JRIGb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 04:06:31 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44169
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751451Ab0JRIGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 04:06:30 -0400
Date: Mon, 18 Oct 2010 01:06:52 -0700 (PDT)
Message-Id: <20101018.010652.193724757.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, shemminger@vyatta.com
Subject: Re: linux-next: build failure after merge of the final tree (net
 tree related)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101018183616.ef5cde84.sfr@canb.auug.org.au>
References: <20101018183616.ef5cde84.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 18 Oct 2010 18:36:16 +1100

> net/tipc/core.c:249: error: __ksymtab_tipc_get_mode causes a section type conflict
> 
> Caused by commit 31e3c3f6f1f9b154981a0e6620df700463db30ee ("tipc: cleanup
> function namespace") which made the EXPORTed function tipc_get_mode() static.
> 
> I have reverted that commit for today.

Thanks I just pushed this fix:

--------------------
tipc: Kill tipc_get_mode() completely.

It's completely unused and exporting a static symbol
makes no sense and breaks the build.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/tipc/core.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/net/tipc/core.c b/net/tipc/core.c
index c005303..e2a09eb 100644
--- a/net/tipc/core.c
+++ b/net/tipc/core.c
@@ -96,11 +96,6 @@ int tipc_net_id;
 int tipc_remote_management;
 
 
-static int tipc_get_mode(void)
-{
-	return tipc_mode;
-}
-
 /**
  * tipc_buf_acquire - creates a TIPC message buffer
  * @size: message size (including TIPC header)
@@ -246,7 +241,6 @@ MODULE_VERSION(TIPC_MOD_VER);
 
 EXPORT_SYMBOL(tipc_attach);
 EXPORT_SYMBOL(tipc_detach);
-EXPORT_SYMBOL(tipc_get_mode);
 EXPORT_SYMBOL(tipc_createport);
 EXPORT_SYMBOL(tipc_deleteport);
 EXPORT_SYMBOL(tipc_ownidentity);
-- 
1.7.3.1

