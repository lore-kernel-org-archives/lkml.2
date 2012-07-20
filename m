Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381Ab2GTDyX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 23:54:23 -0400
Received: from void.printf.net ([89.145.121.20]:44267 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890Ab2GTDyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 23:54:20 -0400
From: Chris Ball <cjb@laptop.org>
To: Shashidhar Hiremath <shashidharh@vayavyalabs.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: A question on printascii
References: <CANYdXnrf-f2e=3YKpwweSmvrYdmy7z_yOEyZ11k=La=8b3W6Pw@mail.gmail.com>
Date: Thu, 19 Jul 2012 23:54:15 -0400
In-Reply-To: <CANYdXnrf-f2e=3YKpwweSmvrYdmy7z_yOEyZ11k=La=8b3W6Pw@mail.gmail.com>
	(Shashidhar Hiremath's message of "Wed, 18 Jul 2012 18:33:03 +0530")
Message-ID: <87hat35bq0.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shashidhar,

On Wed, Jul 18 2012, Shashidhar Hiremath wrote:
>   I want to use printascii to debug my serial driver. How do I enable
> it and use the feature.
>   Currently I have enabled in menuconfig and done an extern on the
> printascii api, this doesn't seem to work, So any hints for debugging
> serial drivers ?

Sounds like you want this patch, against linux-next:

diff --git a/kernel/printk.c b/kernel/printk.c
index 3991862..36abce8 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -45,6 +45,8 @@
 
 #include <asm/uaccess.h>
 
+extern void printascii(char *);
+
 #define CREATE_TRACE_POINTS
 #include <trace/events/printk.h>
 
@@ -1542,6 +1544,8 @@ asmlinkage int vprintk_emit(int facility, int level,
 	 */
 	text_len = vscnprintf(text, sizeof(textbuf), fmt, args);
 
+	printascii(text);
+
 	/* mark and strip a trailing newline */
 	if (text_len && text[text_len-1] == '\n') {
 		text_len--;

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
