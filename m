Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578Ab1JCPsp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 11:48:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:53657 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679Ab1JCPsk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 11:48:40 -0400
Subject: Re: [V7][PATCH 0/6] x86, nmi: new NMI handling routines
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        LKML <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com,
        avi@redhat.com, jeremy@goop.org
Date: Mon, 03 Oct 2011 17:47:18 +0200
In-Reply-To: <1317409584-23662-1-git-send-email-dzickus@redhat.com>
References: <1317409584-23662-1-git-send-email-dzickus@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317656838.20367.28.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I fixed up:


drivers/watchdog/hpwdt.c: In function ‘hpwdt_init_nmi_decoding’:
drivers/watchdog/hpwdt.c:734: error: ‘NMI_HANDLE_FIRST’ undeclared (first use in this function)
drivers/watchdog/hpwdt.c:734: error: (Each undeclared identifier is reported only once
drivers/watchdog/hpwdt.c:734: error: for each function it appears in.)
drivers/watchdog/hpwdt.c:735: warning: passing argument 2 of ‘register_nmi_handler’ from incompatible pointer type

---

Index: linux-2.6/drivers/watchdog/hpwdt.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/hpwdt.c
+++ linux-2.6/drivers/watchdog/hpwdt.c
@@ -477,8 +477,7 @@ static int hpwdt_time_left(void)
 /*
  *	NMI Handler
  */
-static int hpwdt_pretimeout(unsigned int ulReason, struct pt_regs *regs,
-				void *data)
+static int hpwdt_pretimeout(unsigned int ulReason, struct pt_regs *regs)
 {
 	unsigned long rom_pl;
 	static int die_nmi_called;
@@ -731,7 +730,7 @@ static int __devinit hpwdt_init_nmi_deco
 	 * be last so other users of the NMI signal can function.
 	 */
 	retval = register_nmi_handler(NMI_UNKNOWN, hpwdt_pretimeout,
-					(priority) ? NMI_HANDLE_FIRST : 0,
+					(priority) ? NMI_FLAG_FIRST : 0,
 					"hpwdt");
 	if (retval != 0) {
 		dev_warn(&dev->dev,

