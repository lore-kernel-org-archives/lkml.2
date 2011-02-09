Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab1BIQpT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 11:45:19 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:24731 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105Ab1BIQpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 11:45:17 -0500
Date: Wed, 9 Feb 2011 08:44:56 -0800
From: Randy Dunlap <randy.dunlap@Oracle.COM>
To: Stephen Rothwell <sfr@canb.auug.org.au>, netdev <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        davem@davemloft.net, socketcan-core@lists.berlios.de
Subject: [PATCH -next] can: softing_cs needs slab.h
Message-Id: <20110209084456.802370fa.randy.dunlap@oracle.com>
In-Reply-To: <20110209170225.94eae681.sfr@canb.auug.org.au>
References: <20110209170225.94eae681.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4D52C494.0262:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

softing_cs.c uses kzalloc & kfree, so it needs to include linux/slab.h.

drivers/net/can/softing/softing_cs.c:234: error: implicit declaration of function 'kfree'
drivers/net/can/softing/softing_cs.c:271: error: implicit declaration of function 'kzalloc'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/net/can/softing/softing_cs.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20110209.orig/drivers/net/can/softing/softing_cs.c
+++ linux-next-20110209/drivers/net/can/softing/softing_cs.c
@@ -19,6 +19,7 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/slab.h>
 
 #include <pcmcia/cistpl.h>
 #include <pcmcia/ds.h>
