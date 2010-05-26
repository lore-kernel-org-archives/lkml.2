Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133Ab0EZRJ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 13:09:28 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:57802 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755149Ab0EZRJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 13:09:26 -0400
Date: Wed, 26 May 2010 10:08:51 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-media@vger.kernel.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] media/IR: nec-decoder needs to select BITREV
Message-Id: <20100526100851.25b57d9b.randy.dunlap@oracle.com>
In-Reply-To: <20100526153443.f18a4d2b.sfr@canb.auug.org.au>
References: <20100526153443.f18a4d2b.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090204.4BFD55C0.0044:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix ir-nec-decoder build: it uses bitrev library code, so
select BITREVERSE in its Kconfig.

ir-nec-decoder.c:(.text+0x1a2517): undefined reference to `byte_rev_table'
ir-nec-decoder.c:(.text+0x1a2526): undefined reference to `byte_rev_table'
ir-nec-decoder.c:(.text+0x1a2530): undefined reference to `byte_rev_table'
ir-nec-decoder.c:(.text+0x1a2539): undefined reference to `byte_rev_table'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc:	Mauro Carvalho Chehab <mchehab@infradead.org>
---
[resend from May 14, 2010; still needed for linux-next 2010-May-26]

 drivers/media/IR/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20100514.orig/drivers/media/IR/Kconfig
+++ linux-next-20100514/drivers/media/IR/Kconfig
@@ -13,6 +13,7 @@ source "drivers/media/IR/keymaps/Kconfig
 config IR_NEC_DECODER
 	tristate "Enable IR raw decoder for the NEC protocol"
 	depends on IR_CORE
+	select BITREVERSE
 	default y
 
 	---help---
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
