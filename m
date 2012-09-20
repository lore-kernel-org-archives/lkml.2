Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189Ab2ITN6J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 09:58:09 -0400
Received: from mail1.windriver.com ([147.11.146.13]:56596 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635Ab2ITN6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 09:58:07 -0400
Message-ID: <505B20C6.5090308@windriver.com>
Date: Thu, 20 Sep 2012 08:57:26 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Anton Vorontsov <anton.vorontsov@linaro.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        Colin Cross <ccross@android.com>, Brian Swetland <swetland@google.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linaro-kernel@lists.linaro.org>, <patches@linaro.org>,
        <kernel-team@android.com>, <kgdb-bugreport@lists.sourceforge.net>,
        <linux-serial@vger.kernel.org>
Subject: Re: [PATCH 07/11] tty/serial: Add kgdb_nmi driver
References: <20120919234003.GA24143@lizard> <1348098122-11041-7-git-send-email-anton.vorontsov@linaro.org>
In-Reply-To: <1348098122-11041-7-git-send-email-anton.vorontsov@linaro.org>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2012 06:41 PM, Anton Vorontsov wrote:
> This special driver makes it possible to temporary use NMI debugger port
> as a normal console by issuing 'nmi_console' command (assuming that the
> port is attached to KGDB).
> 


The kgdb regression compiler also does checkpatch, so the "check patch
police" don't come chasing us let's get rid of this warning.  This
comes with the disclaimer that I believe checkpatch is a bit overly
agressive in the first place. :-)

WARNING: quoted string split across lines
#133: FILE: drivers/tty/serial/kgdb_nmi.c:36:
+MODULE_PARM_DESC(knock, "if set to 1 (default), the special '$3#33' command "
+                       "must be used to enter the debugger; when set to 0, "

---
 drivers/tty/serial/kgdb_nmi.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/tty/serial/kgdb_nmi.c
+++ b/drivers/tty/serial/kgdb_nmi.c
@@ -32,10 +32,10 @@
 
 static int kgdb_nmi_knock = 1;
 module_param_named(knock, kgdb_nmi_knock, int, 0600);
-MODULE_PARM_DESC(knock, "if set to 1 (default), the special '$3#33' command "
-			"must be used to enter the debugger; when set to 0, "
-			"hitting return key is enough to enter the debugger; "
-			"when set to -1, the debugger is entered immediately "
+MODULE_PARM_DESC(knock, "if set to 1 (default), the special '$3#33' command " \
+			"must be used to enter the debugger; when set to 0, " \
+			"hitting return key is enough to enter the debugger; " \
+			"when set to -1, the debugger is entered immediately " \
 			"upon NMI");
 
 static char *kgdb_nmi_magic = "$3#33";

