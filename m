Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617Ab1JCPxz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 11:53:55 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37385 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab1JCPxu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 11:53:50 -0400
Subject: Re: [V7][PATCH 0/6] x86, nmi: new NMI handling routines
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        LKML <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com,
        avi@redhat.com, jeremy@goop.org
Date: Mon, 03 Oct 2011 17:52:38 +0200
In-Reply-To: <1317409584-23662-1-git-send-email-dzickus@redhat.com>
References: <1317409584-23662-1-git-send-email-dzickus@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317657158.20367.30.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Also fixed:

drivers/char/ipmi/ipmi_watchdog.c: In function ‘ipmi_nmi’:
drivers/char/ipmi/ipmi_watchdog.c:1091: error: ‘NMI_HANDLED’ undeclared (first use in this function)
drivers/char/ipmi/ipmi_watchdog.c:1091: error: (Each undeclared identifier is reported only once
drivers/char/ipmi/ipmi_watchdog.c:1091: error: for each function it appears in.)
drivers/char/ipmi/ipmi_watchdog.c:1096: error: ‘NMI_DONE’ undeclared (first use in this function)
drivers/char/ipmi/ipmi_watchdog.c: In function ‘check_parms’:
drivers/char/ipmi/ipmi_watchdog.c:1280: error: implicit declaration of function ‘register_nmi_handler’
drivers/char/ipmi/ipmi_watchdog.c:1280: error: ‘NMI_UNKNOWN’ undeclared (first use in this function)
drivers/char/ipmi/ipmi_watchdog.c:1289: error: implicit declaration of function ‘unregister_nmi_handler’
drivers/char/ipmi/ipmi_watchdog.c: In function ‘ipmi_wdog_init’:
drivers/char/ipmi/ipmi_watchdog.c:1327: error: ‘NMI_UNKNOWN’ undeclared (first use in this function)
drivers/char/ipmi/ipmi_watchdog.c: In function ‘ipmi_wdog_exit’:
drivers/char/ipmi/ipmi_watchdog.c:1348: error: ‘NMI_UNKNOWN’ undeclared (first use in this function)


---
Index: linux-2.6/drivers/char/ipmi/ipmi_watchdog.c
===================================================================
--- linux-2.6.orig/drivers/char/ipmi/ipmi_watchdog.c
+++ linux-2.6/drivers/char/ipmi/ipmi_watchdog.c
@@ -65,6 +65,7 @@
  * mechanism for it at that time.
  */
 #include <asm/kdebug.h>
+#include <asm/nmi.h>
 #define HAVE_DIE_NMI
 #endif
 

