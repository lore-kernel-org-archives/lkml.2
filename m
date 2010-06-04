Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618Ab0FDQmb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 12:42:31 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:29875 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913Ab0FDQma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 12:42:30 -0400
Date: Fri, 4 Jun 2010 09:41:37 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Mike Miller <mike.miller@hp.com>
Subject: [PATCH -mmotm] cciss: fix build for CONFIG_PROC_FS=n
Message-Id: <20100604094137.0702daa1.randy.dunlap@oracle.com>
In-Reply-To: <201006040005.o5405Afw023296@imap1.linux-foundation.org>
References: <201006040005.o5405Afw023296@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090201.4C092CEA.014D:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build for CONFIG_PROC_FS not enabled; fixes this build error:
drivers/block/cciss.c:3422: error: implicit declaration of function 'next_command'

Looks like the next_command() function was added at a bad location
in cciss-add-performant-mode-support-for-stars-sirius.patch.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Mike Miller <mike.miller@hp.com>
---
 drivers/block/cciss.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- mmotm-2010-0603-1636.orig/drivers/block/cciss.c
+++ mmotm-2010-0603-1636/drivers/block/cciss.c
@@ -372,8 +372,6 @@ static const char *raid_label[] = { "0",
 };
 #define RAID_UNKNOWN (sizeof(raid_label) / sizeof(raid_label[0])-1)
 
-#ifdef CONFIG_PROC_FS
-
 static inline u32 next_command(ctlr_info_t *h)
 {
 	u32 a;
@@ -396,6 +394,8 @@ static inline u32 next_command(ctlr_info
 	return a;
 }
 
+#ifdef CONFIG_PROC_FS
+
 /*
  * Report information about this controller.
  */
