Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759495Ab0D3TOO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 15:14:14 -0400
Received: from rcsinet14.oracle.com ([148.87.113.126]:17087 "EHLO
	rcsinet14.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755402Ab0D3TNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 15:13:05 -0400
Date: Thu, 29 Apr 2010 10:46:32 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org
Cc: devel@driverdev.osuosl.org, gregkh@suse.de,
       Ossama Othman <ossama.othman@intel.com>
Subject: [PATCH -next] memrar: fix printk format warning
Message-Id: <20100429104632.8558f75c.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090209.4BD9C63B.0016:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warning in memrar:
drivers/staging/memrar/memrar_handler.c:393: warning: format '%u' expects type 'unsigned int', but argument 4 has type 'size_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Ossama Othman <ossama.othman@intel.com>
---
 drivers/staging/memrar/memrar_handler.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20100429.orig/drivers/staging/memrar/memrar_handler.c
+++ linux-next-20100429/drivers/staging/memrar/memrar_handler.c
@@ -390,7 +390,7 @@ static int memrar_init_rar_resources(cha
 			(unsigned long) low,
 			(unsigned long) high);
 
-		pr_info("%s: BRAR[%d] size = %u KiB\n",
+		pr_info("%s: BRAR[%d] size = %zu KiB\n",
 			devname,
 			z,
 			rar->allocator->capacity / 1024);
