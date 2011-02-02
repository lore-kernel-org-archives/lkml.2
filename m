Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983Ab1BBAns (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:43:48 -0500
Received: from mga02.intel.com ([134.134.136.20]:46559 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798Ab1BBAnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:43:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="703028353"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: davem@davemloft.net, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [41/139] sparc: Do not export prom_nb{get,put}char().
Message-Id: <20110202004356.B0C4C3E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:43:56 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: David S. Miller <davem@davemloft.net>

[ Upstream commit 91921fef7c658b12de53376b312d071d757f7770 ]

Never used outside of console_{32,64}.c

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/sparc/include/asm/oplib_32.h |    6 ------
 arch/sparc/include/asm/oplib_64.h |    6 ------
 arch/sparc/prom/console_32.c      |    6 ++----
 arch/sparc/prom/console_64.c      |    6 ++----
 4 files changed, 4 insertions(+), 20 deletions(-)

Index: linux-2.6.35.y/arch/sparc/include/asm/oplib_32.h
===================================================================
--- linux-2.6.35.y.orig/arch/sparc/include/asm/oplib_32.h
+++ linux-2.6.35.y/arch/sparc/include/asm/oplib_32.h
@@ -104,12 +104,6 @@ extern int prom_getprev(void);
 
 /* Character operations to/from the console.... */
 
-/* Non-blocking get character from console. */
-extern int prom_nbgetchar(void);
-
-/* Non-blocking put character to console. */
-extern int prom_nbputchar(char character);
-
 /* Blocking get character from console. */
 extern char prom_getchar(void);
 
Index: linux-2.6.35.y/arch/sparc/include/asm/oplib_64.h
===================================================================
--- linux-2.6.35.y.orig/arch/sparc/include/asm/oplib_64.h
+++ linux-2.6.35.y/arch/sparc/include/asm/oplib_64.h
@@ -96,12 +96,6 @@ extern unsigned char prom_get_idprom(cha
 
 /* Character operations to/from the console.... */
 
-/* Non-blocking get character from console. */
-extern int prom_nbgetchar(void);
-
-/* Non-blocking put character to console. */
-extern int prom_nbputchar(char character);
-
 /* Blocking get character from console. */
 extern char prom_getchar(void);
 
Index: linux-2.6.35.y/arch/sparc/prom/console_32.c
===================================================================
--- linux-2.6.35.y.orig/arch/sparc/prom/console_32.c
+++ linux-2.6.35.y/arch/sparc/prom/console_32.c
@@ -19,8 +19,7 @@ extern void restore_current(void);
 /* Non blocking get character from console input device, returns -1
  * if no input was taken.  This can be used for polling.
  */
-int
-prom_nbgetchar(void)
+static int prom_nbgetchar(void)
 {
 	static char inc;
 	int i = -1;
@@ -51,8 +50,7 @@ prom_nbgetchar(void)
 /* Non blocking put character to console device, returns -1 if
  * unsuccessful.
  */
-int
-prom_nbputchar(char c)
+static int prom_nbputchar(char c)
 {
 	static char outc;
 	unsigned long flags;
Index: linux-2.6.35.y/arch/sparc/prom/console_64.c
===================================================================
--- linux-2.6.35.y.orig/arch/sparc/prom/console_64.c
+++ linux-2.6.35.y/arch/sparc/prom/console_64.c
@@ -18,8 +18,7 @@ extern int prom_stdin, prom_stdout;
 /* Non blocking get character from console input device, returns -1
  * if no input was taken.  This can be used for polling.
  */
-inline int
-prom_nbgetchar(void)
+static int prom_nbgetchar(void)
 {
 	unsigned long args[7];
 	char inc;
@@ -42,8 +41,7 @@ prom_nbgetchar(void)
 /* Non blocking put character to console device, returns -1 if
  * unsuccessful.
  */
-inline int
-prom_nbputchar(char c)
+static int prom_nbputchar(char c)
 {
 	unsigned long args[7];
 	char outc;
