Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832Ab1HCRMd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 13:12:33 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:37973 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754405Ab1HCRM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 13:12:28 -0400
Date: Wed, 3 Aug 2011 10:12:26 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: akpm@linux-foundation.org, linux-media@vger.kernel.org,
        mchehab@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-next@vger.kernel.org
Subject: [PATCH -mmotm] media: video/adp1653.c needs module.h
Message-Id: <20110803101226.0d17b23e.rdunlap@xenotime.net>
In-Reply-To: <201108022357.p72NvsZM022462@imap1.linux-foundation.org>
References: <201108022357.p72NvsZM022462@imap1.linux-foundation.org>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

adp1653.c uses interfaces that are provided by <linux/module.h>
and needs to include that header file to fix build errors.

drivers/media/video/adp1653.c:453: warning: data definition has no type or storage class
drivers/media/video/adp1653.c:453: warning: parameter names (without types) in function declaration
drivers/media/video/adp1653.c:474: error: 'THIS_MODULE' undeclared (first use in this function)
and more.

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/media/video/adp1653.c |    1 +
 1 file changed, 1 insertion(+)

--- mmotm-2011-0802-1619.orig/drivers/media/video/adp1653.c
+++ mmotm-2011-0802-1619/drivers/media/video/adp1653.c
@@ -32,6 +32,7 @@
 
 #include <linux/delay.h>
 #include <linux/i2c.h>
+#include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/version.h>
 #include <media/adp1653.h>
