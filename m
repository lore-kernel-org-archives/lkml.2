Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557Ab1JLGam (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 02:30:42 -0400
Received: from cluster-d.mailcontrol.com ([85.115.60.190]:58839 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab1JLGak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 02:30:40 -0400
From: Barry Song <Barry.Song@csr.com>
To: <pavel@ucw.cz>
CC: <rjw@sisk.pl>, <linux-kernel@vger.kernel.org>, <workgroup.linux@csr.com>,
        <linux-pm@lists.linux-foundation.org>,
        Barry Song <Baohua.Song@csr.com>, Borislav Petkov <bp@alien8.de>
Subject: [PATCH] PM: HIBERNATION: do not initialise statics and externals to 0 or NULL
Date: Tue, 11 Oct 2011 23:29:18 -0700
Message-ID: <1318400958-21481-1-git-send-email-Barry.Song@csr.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.125.36.62]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Barry Song <Baohua.Song@csr.com>

Cc: Borislav Petkov <bp@alien8.de>
Signed-off-by: Barry Song <Baohua.Song@csr.com>
---
 This patch depends on Barry Song's
 PM: HIBERNATION: add resume_wait param to support MMC-like devices as resume file;
 http://www.spinics.net/lists/linux-mmc/msg10282.html
 PM: HIBERNATION: add resume_delay kernel param;
 http://www.spinics.net/lists/linux-mmc/msg10478.html

 kernel/power/hibernate.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index f73a00e..19d443b 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -30,14 +30,14 @@
 #include "power.h"
 
 
-static int nocompress = 0;
-static int noresume = 0;
-static int resume_wait = 0;
-static int resume_delay = 0;
+static int nocompress;
+static int noresume;
+static int resume_wait;
+static int resume_delay;
 static char resume_file[256] = CONFIG_PM_STD_PARTITION;
 dev_t swsusp_resume_device;
 sector_t swsusp_resume_block;
-int in_suspend __nosavedata = 0;
+int in_suspend __nosavedata;
 
 enum {
 	HIBERNATION_INVALID,
-- 
1.7.1



Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom
More information can be found at www.csr.com. Follow CSR on Twitter at http://twitter.com/CSR_PLC and read our blog at www.csr.com/blog
