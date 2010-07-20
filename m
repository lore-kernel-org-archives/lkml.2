Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933074Ab0GTXEq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 19:04:46 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:54597 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932810Ab0GTXEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 19:04:44 -0400
Message-ID: <4C462B44.5010107@oracle.com>
Date: Tue, 20 Jul 2010 16:03:32 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: sfr@canb.auug.org.au, netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lennert Buytenhek <buytenh@wantstofly.org>
Subject: [PATCH -next] net: NET_DSA depends on NET_ETHERNET
References: <20100706190519.93d8b785.sfr@canb.auug.org.au>	<20100706103417.8923b697.randy.dunlap@oracle.com> <20100710.190954.245403400.davem@davemloft.net>
In-Reply-To: <20100710.190954.245403400.davem@davemloft.net>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4C462B81.01C7:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

NET_DSA code selects and uses PHYLIB code, but PHYLIB depends on
NET_ETHERNET.  However, "select" does not follow kconfig dependencies,
so explicitly list that requirement here instead.

Fixes this kconfig warning:

warning: (NET_DSA && NET && EXPERIMENTAL && !S390 ...) selects PHYLIB which has unmet direct dependencies (!S390 && NET_ETHERNET)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Lennert Buytenhek <buytenh@wantstofly.org>
---
 net/dsa/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Is there some reason that NET_DSA is bool instead of tristate?
I.e., net/dsa/ code cannot be built as loadable modules?
--- linux-next-20100713.orig/net/dsa/Kconfig
+++ linux-next-20100713/net/dsa/Kconfig
@@ -1,7 +1,7 @@
 menuconfig NET_DSA
 	bool "Distributed Switch Architecture support"
 	default n
-	depends on EXPERIMENTAL && !S390
+	depends on EXPERIMENTAL && !S390 && NET_ETHERNET
 	select PHYLIB
 	---help---
 	  This allows you to use hardware switch chips that use
