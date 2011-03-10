Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414Ab1CJX5Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 18:57:16 -0500
Received: from kroah.org ([198.145.64.141]:45174 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754311Ab1CJX5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 18:57:12 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Mar 10 15:55:36 2011
Message-Id: <20110310235536.318936726@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 10 Mar 2011 15:54:09 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Carpenter <error27@gmail.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 03/29] [S390] keyboard: integer underflow bug
In-Reply-To: <20110310235548.GA10103@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

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
@@ -460,7 +460,8 @@ kbd_ioctl(struct kbd_data *kbd, struct f
 	  unsigned int cmd, unsigned long arg)
 {
 	void __user *argp;
-	int ct, perm;
+	unsigned int ct;
+	int perm;
 
 	argp = (void __user *)arg;
 


