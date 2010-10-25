Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab0JYHOS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 03:14:18 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43598 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485Ab0JYHOR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 03:14:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=sj36Vs0LWp7eXVxsSxY19bJpogCKx9+IBnvqsJ8Q/gE1jRhQNo0nJgfZDOqqb3To9r
         kPKxoBeieEaYkUIzGBHv1DGeT8ZQJgNN6clLtXhGyh8c+WwRKtpXBv/GkCfjgDjIXrCf
         IPWD6+1tFO3l3YJdQsYO3Ce71zyyuSsXo9i3Q=
MIME-Version: 1.0
Date: Mon, 25 Oct 2010 13:14:15 +0600
Message-ID: <AANLkTi=wE=nB_FXupXVYoetSEg9n2uQ6_HRz8d42e4GW@mail.gmail.com>
Subject: [PATCH]: char, mxser: Fix compilation warning in mxser.c
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jiri Slaby <jirislaby@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Kulikov Vasiliy <segooon@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both function mxser_disable_must_enchance_mode() and
mxser_get_must_hardware_id() called from function CheckIsMoxaMust(),
when CONFIG_PCI=y. So mark both the functions under CONFIG_PCI.

We were warned by the following warning.

drivers/char/mxser.c:306: warning: ‘mxser_disable_must_enchance_mode’
defined but not used
drivers/char/mxser.c:391: warning: ‘mxser_get_must_hardware_id’
defined but not used


Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
---

diff --git a/drivers/char/mxser.c b/drivers/char/mxser.c
index 3fc89da..2bdadd4 100644
--- a/drivers/char/mxser.c
+++ b/drivers/char/mxser.c
@@ -303,6 +303,7 @@ static void
mxser_enable_must_enchance_mode(unsigned long baseio)
 	outb(oldlcr, baseio + UART_LCR);
 }

+#ifdef	CONFIG_PCI
 static void mxser_disable_must_enchance_mode(unsigned long baseio)
 {
 	u8 oldlcr;
@@ -317,6 +318,7 @@ static void
mxser_disable_must_enchance_mode(unsigned long baseio)
 	outb(efr, baseio + MOXA_MUST_EFR_REGISTER);
 	outb(oldlcr, baseio + UART_LCR);
 }
+#endif

 static void mxser_set_must_xon1_value(unsigned long baseio, u8 value)
 {
@@ -388,6 +390,7 @@ static void mxser_set_must_enum_value(unsigned
long baseio, u8 value)
 	outb(oldlcr, baseio + UART_LCR);
 }

+#ifdef CONFIG_PCI
 static void mxser_get_must_hardware_id(unsigned long baseio, u8 *pId)
 {
 	u8 oldlcr;
@@ -404,6 +407,7 @@ static void mxser_get_must_hardware_id(unsigned
long baseio, u8 *pId)
 	*pId = inb(baseio + MOXA_MUST_HWID_REGISTER);
 	outb(oldlcr, baseio + UART_LCR);
 }
+#endif

 static void SET_MOXA_MUST_NO_SOFTWARE_FLOW_CONTROL(unsigned long baseio)
 {
