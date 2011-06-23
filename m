Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932808Ab1FWRWj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:22:39 -0400
Received: from mail.windriver.com ([147.11.1.11]:63146 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932760Ab1FWRWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:22:31 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 037/247] radio-aimslab.c needs #include <linux/delay.h>
Date: Thu, 23 Jun 2011 13:18:00 -0400
Message-Id: <1308849690-14530-38-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 2400982a2e8a8e4e95f0a0e1517bbe63cc88038f upstream.

Commit e3c92215198cb6aa00ad38db2780faa6b72e0a3f ("[media] radio-aimslab.c: Fix
gcc 4.5+ bug") removed the include, but introduced new callers of msleep():

| drivers/media/radio/radio-aimslab.c: In function ‘rt_decvol’:
| drivers/media/radio/radio-aimslab.c:76: error: implicit declaration of function ‘msleep’

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/media/radio/radio-aimslab.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/radio/radio-aimslab.c b/drivers/media/radio/radio-aimslab.c
index 1944814..a91642c 100644
--- a/drivers/media/radio/radio-aimslab.c
+++ b/drivers/media/radio/radio-aimslab.c
@@ -31,6 +31,7 @@
 #include <linux/module.h>	/* Modules 			*/
 #include <linux/init.h>		/* Initdata			*/
 #include <linux/ioport.h>	/* request_region		*/
+#include <linux/delay.h>	/* msleep			*/
 #include <linux/videodev2.h>	/* kernel radio structs		*/
 #include <linux/version.h>	/* for KERNEL_VERSION MACRO	*/
 #include <linux/io.h>		/* outb, outb_p			*/
-- 
1.7.4.4

