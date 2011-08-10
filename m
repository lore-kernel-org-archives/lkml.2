Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849Ab1HJMC5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 08:02:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:50075 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753343Ab1HJMC4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 08:02:56 -0400
From: "Voss, Nikolaus" <N.Voss@weinmann.de>
To: "'Jean-Christophe PLAGNIOL-VILLARD'" <plagnioj@jcrosoft.com>,
        "'Sergei Shtylyov'" <sshtylyov@mvista.com>
CC: "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'Nicolas Ferre'" <nicolas.ferre@atmel.com>,
        "'Greg Kroah-Hartman'" <gregkh@suse.de>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>
Date: Wed, 10 Aug 2011 14:02:29 +0200
Subject: [PATCH v2] atmel_serial: fix atmel_default_console_device
Thread-Topic: [PATCH v2] atmel_serial: fix atmel_default_console_device
Thread-Index: AcxXTpTg1kxcErisTRSALcMYOlv4GQABlCNQ
Message-ID: <EF2E73589CA71846A15D0B2CDF79505D087B055C3A@wm021.weinmann.com>
References: <1307541740.10626.15.camel@hcegtvedt.norway.atmel.com>
 <1308666679-12111-1-git-send-email-plagnioj@jcrosoft.com>
 <loom.20110808T170457-559@post.gmane.org> <4E411CEF.10004@ru.mvista.com>
 <EF2E73589CA71846A15D0B2CDF79505D087B0192D6@wm021.weinmann.com>
 <4E4267BF.5040609@ru.mvista.com>
In-Reply-To: <4E4267BF.5040609@ru.mvista.com>
Accept-Language: en-US, de-DE
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, de-DE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Greylist: Delayed for 21:46:01 by milter-greylist-4.2.3 (hera.kernel.org [140.211.167.34]); Wed, 10 Aug 2011 12:02:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reflect new static uart platform ids introduced by patch
http://article.gmane.org/gmane.linux.kernel/1126105

Signed-off-by: Nikolaus Voss <n.voss@weinmann.de>
---
Updated with Sergei's comment.

 drivers/tty/serial/atmel_serial.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index af9b781..b922f5d 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -1609,9 +1609,11 @@ static struct console atmel_console = {
 static int __init atmel_console_init(void)
 {
 	if (atmel_default_console_device) {
-		add_preferred_console(ATMEL_DEVICENAME,
-				      atmel_default_console_device->id, NULL);
-		atmel_init_port(&atmel_ports[atmel_default_console_device->id],
+		struct atmel_uart_data *pdata =
+			atmel_default_console_device->dev.platform_data;
+
+		add_preferred_console(ATMEL_DEVICENAME, pdata->num, NULL);
+		atmel_init_port(&atmel_ports[pdata->num],
 				atmel_default_console_device);
 		register_console(&atmel_console);
 	}
-- 
1.7.4.1

