Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161525Ab2COUzx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 16:55:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161445Ab2COUzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 16:55:32 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 01/38] ARM: Fix missing linux/types.h #inclusion in
 asm/hardware/iop3xx.h [ver #3]
To: paul.gortmaker@windriver.com
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, arnd@arndb.de,
        David Howells <dhowells@redhat.com>
Date: Thu, 15 Mar 2012 20:55:26 +0000
Message-ID: <20120315205526.28759.26737.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120315205514.28759.58969.stgit@warthog.procyon.org.uk>
References: <20120315205514.28759.58969.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/arm/include/asm/hardware/iop3xx.h needs to include linux/types.h to avoid
the following errors:

In file included from arch/arm/plat-iop/restart.c:10:0:
/data/fs/linux-2.6-fscache/arch/arm/include/asm/hardware/iop3xx.h:239:1: error: unknown type name 'u32'
/data/fs/linux-2.6-fscache/arch/arm/include/asm/hardware/iop3xx.h: In function 'read_tmr0':
/data/fs/linux-2.6-fscache/arch/arm/include/asm/hardware/iop3xx.h:241:2: error: unknown type name 'u32'
/data/fs/linux-2.6-fscache/arch/arm/include/asm/hardware/iop3xx.h: At top level:
/data/fs/linux-2.6-fscache/arch/arm/include/asm/hardware/iop3xx.h:246:31: error: unknown type name 'u32'
...

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/arm/include/asm/hardware/iop3xx.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/arm/include/asm/hardware/iop3xx.h b/arch/arm/include/asm/hardware/iop3xx.h
index 077c323..2ff2c75 100644
--- a/arch/arm/include/asm/hardware/iop3xx.h
+++ b/arch/arm/include/asm/hardware/iop3xx.h
@@ -231,6 +231,9 @@ extern int iop3xx_get_init_atu(void);
 
 
 #ifndef __ASSEMBLY__
+
+#include <linux/types.h>
+
 void iop3xx_map_io(void);
 void iop_init_cp6_handler(void);
 void iop_init_time(unsigned long tickrate);

