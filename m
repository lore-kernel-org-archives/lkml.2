Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072Ab2BAJwk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 04:52:40 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34708 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405Ab2BAJwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 04:52:39 -0500
Message-ID: <4F290B63.9090101@gmail.com>
Date: Wed, 01 Feb 2012 10:52:35 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120124 Thunderbird/10.0
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: gregkh@suse.de, linux-kernel@vger.kernel.org, alan@linux.intel.com
Subject: Re: [PATCH 3/5] TTY: use tty_standard_install
References: <1327954472-26594-1-git-send-email-jslaby@suse.cz> <1327954472-26594-3-git-send-email-jslaby@suse.cz> <4F290877.8050406@gmail.com>
In-Reply-To: <4F290877.8050406@gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: multipart/mixed;
 boundary="------------030109040605070306010102"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030109040605070306010102
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit

On 02/01/2012 10:40 AM, Jiri Slaby wrote:
> On 01/30/2012 09:14 PM, Jiri Slaby wrote:
>> Use the helper in the rest of the tty drivers. This is a simple
>> replacement.
>>
>> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
>> Cc: Greg Kroah-Hartman <gregkh@suse.de>
>> Cc: Alan Cox <alan@linux.intel.com>
>> ---
>>  drivers/isdn/capi/capi.c     |    9 +++------
>>  drivers/misc/pti.c           |    6 +-----
>>  drivers/mmc/card/sdio_uart.c |    9 +++------
>>  drivers/tty/nozomi.c         |    8 ++------
>>  4 files changed, 9 insertions(+), 23 deletions(-)
>>
>> diff --git a/drivers/isdn/capi/capi.c b/drivers/isdn/capi/capi.c
>> index e44933d..ca9261a 100644
>> --- a/drivers/isdn/capi/capi.c
>> +++ b/drivers/isdn/capi/capi.c
>> @@ -1015,14 +1015,11 @@ capinc_tty_install(struct tty_driver *driver, struct tty_struct *tty)
>>  {
>>  	int idx = tty->index;
>>  	struct capiminor *mp = capiminor_get(idx);
>> -	int ret = tty_init_termios(tty);
>> +	int ret = tty_standard_install(tty);
> 
> Uh, what version of the patch did I send? tty_standard_install takes 2
> arguments! I will post the correct one in a moment.

If my ISP's smtp server actually worked now. The patch is attached,
hopefully my mailer won't screw it.

thanks,
-- 
js

--------------030109040605070306010102
Content-Type: text/x-patch;
 name="0003-TTY-use-tty_standard_install.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0003-TTY-use-tty_standard_install.patch"

>From fa0824d0cc22bafe62137b2b33998c8d55ce2ac5 Mon Sep 17 00:00:00 2001
From: Jiri Slaby <jslaby@suse.cz>
Date: Wed, 23 Nov 2011 22:31:01 +0100
Subject: [PATCH v2 3/5] TTY: use tty_standard_install

Use the helper in the rest of the tty drivers. This is a simple
replacement.

[v2] with correct number of parameters...

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@linux.intel.com>
---
 drivers/isdn/capi/capi.c     |    9 +++------
 drivers/misc/pti.c           |    6 +-----
 drivers/mmc/card/sdio_uart.c |    9 +++------
 drivers/tty/nozomi.c         |    8 ++------
 4 files changed, 9 insertions(+), 23 deletions(-)

diff --git a/drivers/isdn/capi/capi.c b/drivers/isdn/capi/capi.c
index e44933d..94948be 100644
--- a/drivers/isdn/capi/capi.c
+++ b/drivers/isdn/capi/capi.c
@@ -1015,14 +1015,11 @@ capinc_tty_install(struct tty_driver *driver, struct tty_struct *tty)
 {
 	int idx = tty->index;
 	struct capiminor *mp = capiminor_get(idx);
-	int ret = tty_init_termios(tty);
+	int ret = tty_standard_install(driver, tty);
 
-	if (ret == 0) {
-		tty_driver_kref_get(driver);
-		tty->count++;
+	if (ret == 0)
 		tty->driver_data = mp;
-		driver->ttys[idx] = tty;
-	} else
+	else
 		capiminor_put(mp);
 	return ret;
 }
diff --git a/drivers/misc/pti.c b/drivers/misc/pti.c
index 0b56e3f..471ff4c 100644
--- a/drivers/misc/pti.c
+++ b/drivers/misc/pti.c
@@ -481,13 +481,9 @@ static int pti_tty_install(struct tty_driver *driver, struct tty_struct *tty)
 {
 	int idx = tty->index;
 	struct pti_tty *pti_tty_data;
-	int ret = tty_init_termios(tty);
+	int ret = tty_standard_install(driver, tty);
 
 	if (ret == 0) {
-		tty_driver_kref_get(driver);
-		tty->count++;
-		driver->ttys[idx] = tty;
-
 		pti_tty_data = kmalloc(sizeof(struct pti_tty), GFP_KERNEL);
 		if (pti_tty_data == NULL)
 			return -ENOMEM;
diff --git a/drivers/mmc/card/sdio_uart.c b/drivers/mmc/card/sdio_uart.c
index 2c151e1..bd4a67c 100644
--- a/drivers/mmc/card/sdio_uart.c
+++ b/drivers/mmc/card/sdio_uart.c
@@ -750,15 +750,12 @@ static int sdio_uart_install(struct tty_driver *driver, struct tty_struct *tty)
 {
 	int idx = tty->index;
 	struct sdio_uart_port *port = sdio_uart_port_get(idx);
-	int ret = tty_init_termios(tty);
+	int ret = tty_standard_install(driver, tty);
 
-	if (ret == 0) {
-		tty_driver_kref_get(driver);
-		tty->count++;
+	if (ret == 0)
 		/* This is the ref sdio_uart_port get provided */
 		tty->driver_data = port;
-		driver->ttys[idx] = tty;
-	} else
+	else
 		sdio_uart_port_put(port);
 	return ret;
 }
diff --git a/drivers/tty/nozomi.c b/drivers/tty/nozomi.c
index fd347ff..580da78 100644
--- a/drivers/tty/nozomi.c
+++ b/drivers/tty/nozomi.c
@@ -1602,13 +1602,9 @@ static int ntty_install(struct tty_driver *driver, struct tty_struct *tty)
 	int ret;
 	if (!port || !dc || dc->state != NOZOMI_STATE_READY)
 		return -ENODEV;
-	ret = tty_init_termios(tty);
-	if (ret == 0) {
-		tty_driver_kref_get(driver);
-		tty->count++;
+	ret = tty_standard_install(driver, tty);
+	if (ret == 0)
 		tty->driver_data = port;
-		driver->ttys[tty->index] = tty;
-	}
 	return ret;
 }
 
-- 
1.7.8.3


--------------030109040605070306010102--
