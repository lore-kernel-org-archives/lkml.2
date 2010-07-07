Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156Ab0GGXnM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 19:43:12 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:64323 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756281Ab0GGXnK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 19:43:10 -0400
Date: Wed, 7 Jul 2010 16:41:15 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Jarod Wilson <jarod@redhat.com>,
       David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-media@vger.kernel.org
Subject: [PATCH -next] IR: jvc-decoder needs BITREVERSE
Message-Id: <20100707164115.1682b172.randy.dunlap@oracle.com>
In-Reply-To: <20100707165539.957e7d1c.sfr@canb.auug.org.au>
References: <20100707165539.957e7d1c.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4C3510F2.003A:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

ir-jvc-decoder uses bitreverse interfaces, so it should select
BITREVERSE.

ir-jvc-decoder.c:(.text+0x550bc): undefined reference to `byte_rev_table'
ir-jvc-decoder.c:(.text+0x550c6): undefined reference to `byte_rev_table'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jarod Wilson <jarod@redhat.com>
Cc: David Härdeman <david@hardeman.nu>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
---
 drivers/media/IR/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20100707.orig/drivers/media/IR/Kconfig
+++ linux-next-20100707/drivers/media/IR/Kconfig
@@ -53,6 +53,7 @@ config IR_RC6_DECODER
 config IR_JVC_DECODER
 	tristate "Enable IR raw decoder for the JVC protocol"
 	depends on IR_CORE
+	select BITREVERSE
 	default y
 
 	---help---
