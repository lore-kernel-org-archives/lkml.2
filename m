Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932872Ab1DYUy0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:54:26 -0400
Received: from 1wt.eu ([62.212.114.60]:33992 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756924Ab1DYUYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:24:18 -0400
Message-Id: <20110425200236.037745709@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:03:42 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Dan Carpenter <error27@gmail.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 070/173] [S390] keyboard: integer underflow bug
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Carpenter <error27@gmail.com>

commit b652277b09d3d030cb074cc6a98ba80b34244c03 upstream.

The "ct" variable should be an unsigned int.  Both struct kbdiacrs
->kb_cnt and struct kbd_data ->accent_table_size are unsigned ints.

Making it signed causes a problem in KBDIACRUC because the user could
set the signed bit and cause a buffer overflow.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/s390/char/keyboard.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/s390/char/keyboard.c
+++ b/drivers/s390/char/keyboard.c
@@ -462,7 +462,8 @@ kbd_ioctl(struct kbd_data *kbd, struct f
 	  unsigned int cmd, unsigned long arg)
 {
 	void __user *argp;
-	int ct, perm;
+	unsigned int ct;
+	int perm;
 
 	argp = (void __user *)arg;
 


