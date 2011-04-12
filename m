Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758123Ab1DLQSI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 12:18:08 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:50903 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757970Ab1DLQSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 12:18:05 -0400
Date: Tue, 12 Apr 2011 09:17:35 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Chris Ball <cjb@laptop.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org
Subject: [PATCH -next] mmc quirks: fix truncation warnings
Message-Id: <20110412091735.f41a3d44.randy.dunlap@oracle.com>
In-Reply-To: <20110412151408.b80a3afb.sfr@canb.auug.org.au>
References: <20110412151408.b80a3afb.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4DA47B23.011D:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix data truncation warnings: .manfid is not unsigned long:

drivers/mmc/core/quirks.c:36: warning: large integer implicitly truncated to unsigned type
drivers/mmc/core/quirks.c:40: warning: large integer implicitly truncated to unsigned type
drivers/mmc/core/quirks.c:43: warning: large integer implicitly truncated to unsigned type
drivers/mmc/core/quirks.c:46: warning: large integer implicitly truncated to unsigned type

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc:	Chris Ball <cjb@laptop.org>
Cc:	linux-mmc@vger.kernel.org
---
 include/linux/mmc/card.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20110412.orig/include/linux/mmc/card.h
+++ linux-next-20110412/include/linux/mmc/card.h
@@ -180,7 +180,7 @@ struct mmc_fixup {
 	int data;
 };
 
-#define CID_MANFID_ANY (-1ul)
+#define CID_MANFID_ANY (-1u)
 #define CID_OEMID_ANY ((unsigned short) -1)
 #define CID_NAME_ANY (NULL)
 
