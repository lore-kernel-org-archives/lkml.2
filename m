Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757970Ab1EZROe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 13:14:34 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:43169 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693Ab1EZROd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 13:14:33 -0400
Date: Thu, 26 May 2011 22:44:22 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        Vivek Goyal <vgoyal@redhat.com>, kexec@lists.infradead.org,
        "Eric W. Biederman" <ebiederm@xmission.com>, anderson@redhat.com
Subject: [Bugfix][Patch 3/3] Invoke vpanic inside xpanic function
Message-ID: <20110526171422.GC17988@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20110526170722.GB23266@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110526170722.GB23266@in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Invoke vpanic inside xpanic function

xpanic must invoke the worker routine vpanic to perform the erstwhile panic
related function. Instead it erroneously invokes xpanic (recursively) which
needs to be fixed.

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
---
 kernel/panic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.slim_kdump/kernel/panic.c
===================================================================
--- linux-2.6.slim_kdump.orig/kernel/panic.c
+++ linux-2.6.slim_kdump/kernel/panic.c
@@ -70,7 +70,7 @@ NORET_TYPE void xpanic(enum panic_flags
 {
 	va_list ap;
 	va_start(ap, fmt);
-	xpanic(flags, timeout, fmt, ap);
+	vpanic(flags, timeout, fmt, ap);
 }
 EXPORT_SYMBOL(xpanic);
 
