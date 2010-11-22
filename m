Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847Ab0KVSDk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 13:03:40 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49679 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438Ab0KVSDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 13:03:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=x19jLiJHI3JYYxwgKjfpRiv8v97AmIjPkc/aGZIBnV9xijQYrp/lo5uXaeVpUmFRhE
         cVfVL7lYa5bUjYFyZka9X5eu4e8UNuETJSpthVVNBnwQ1nr3OPMh3+nuGrjHC3ozlfAI
         s+ImP1sUwzxse5Y9m6jqj9EV+wVhXY5h+I1Ao=
From: Vasiliy Kulikov <segoon@openwall.com>
To: kernel-janitors@vger.kernel.org
Cc: Dave Airlie <airlied@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tiago Vignatti <tiago.vignatti@nokia.com>,
        Mike Travis <travis@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] gpu: vga: limit kmalloc'ed memory size
Date: Mon, 22 Nov 2010 20:11:03 +0300
Message-Id: <1290445864-13657-1-git-send-email-segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

count is not checked before kmalloc() call.  Too big value would
generate stack dump.  To prevent this limit 'count' maximum value.
1024 looks OK - the data should be the string of tens of bytes.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 Compile tested only.

 v1 had incorrect comment text, as Dan Rosenberg noticed.

 drivers/gpu/vga/vgaarb.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/vga/vgaarb.c b/drivers/gpu/vga/vgaarb.c
index c380c65..09e3090 100644
--- a/drivers/gpu/vga/vgaarb.c
+++ b/drivers/gpu/vga/vgaarb.c
@@ -836,6 +836,8 @@ static ssize_t vga_arb_write(struct file *file, const char __user * buf,
 	int ret_val;
 	int i;
 
+	if (count > 1024)
+		count = 1024;
 
 	kbuf = kmalloc(count + 1, GFP_KERNEL);
 	if (!kbuf)
-- 
1.7.0.4

