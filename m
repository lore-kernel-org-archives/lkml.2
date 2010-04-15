Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295Ab0DOTbc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 15:31:32 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:47978 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756238Ab0DOTbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 15:31:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type;
        b=Kj58iBYAiD7CdGtM4QVGPwxn5pGlB2yKqBN5iHgtVpOGL/NLSpdJr4l9yMdO+CnCre
         PCyY9Ia3EjgpnMvAL/gV+cPkG+ItFgnBBJA0OibIbWhiDt9hi6QGz3q422Ein1Jg0iTk
         3WzhyJZ2molhXc5Ex+/4+r+CqyNx6VnG7D8s8=
MIME-Version: 1.0
Date: Thu, 15 Apr 2010 21:31:26 +0200
X-Google-Sender-Auth: ebbcf25ac3dd5aae
Message-ID: <y2h10f740e81004151231x19995990y60bbab2aa389026b@mail.gmail.com>
Subject: [PATCH] serial167: Kill unused variables
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Alan Cox <alan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-m68k <linux-m68k@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commits 638157bc1461f6718eeca06bedd9a09cf1f35c36 ("serial167: prepare to push
BKL down into drivers") and 4165fe4ef7305609a96c7f248cefb9c414d0ede5 ("tty:
Fix up char drivers request_room usage") removed code without removing the
corresponding variables:

| drivers/char/serial167.c: In function 'cd2401_rx_interrupt':
| drivers/char/serial167.c:630: warning: unused variable 'len'
| drivers/char/serial167.c: In function 'cy_ioctl':
| drivers/char/serial167.c:1531: warning: unused variable 'val'

Remove the variables to kill the warnings.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/char/serial167.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/char/serial167.c b/drivers/char/serial167.c
index 8dfd247..78a62eb 100644
--- a/drivers/char/serial167.c
+++ b/drivers/char/serial167.c
@@ -627,7 +627,6 @@ static irqreturn_t cd2401_rx_interrupt(int irq,
void *dev_id)
 	char data;
 	int char_count;
 	int save_cnt;
-	int len;

 	/* determine the channel and change to that context */
 	channel = (u_short) (base_addr[CyLICR] >> 2);
@@ -1528,7 +1527,6 @@ static int
 cy_ioctl(struct tty_struct *tty, struct file *file,
 	 unsigned int cmd, unsigned long arg)
 {
-	unsigned long val;
 	struct cyclades_port *info = tty->driver_data;
 	int ret_val = 0;
 	void __user *argp = (void __user *)arg;
-- 
1.6.0.4

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
