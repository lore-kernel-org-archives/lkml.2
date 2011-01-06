Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab1AFA3o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:29:44 -0500
Received: from kroah.org ([198.145.64.141]:35651 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754135Ab1AFA3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:29:40 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:01 2011
Message-Id: <20110106002301.321811117@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:22:28 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>
Subject: [049/152] sparc: Do not export prom_nb{get,put}char().
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------


From: David S. Miller <davem@davemloft.net>

[ Upstream commit 91921fef7c658b12de53376b312d071d757f7770 ]

Never used outside of console_{32,64}.c

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/sparc/include/asm/oplib_32.h |    6 ------
 arch/sparc/include/asm/oplib_64.h |    6 ------
 arch/sparc/prom/console_32.c      |    6 ++----
 arch/sparc/prom/console_64.c      |    6 ++----
 4 files changed, 4 insertions(+), 20 deletions(-)

--- a/arch/sparc/include/asm/oplib_32.h
+++ b/arch/sparc/include/asm/oplib_32.h
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
 
--- a/arch/sparc/include/asm/oplib_64.h
+++ b/arch/sparc/include/asm/oplib_64.h
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
 
--- a/arch/sparc/prom/console_32.c
+++ b/arch/sparc/prom/console_32.c
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
--- a/arch/sparc/prom/console_64.c
+++ b/arch/sparc/prom/console_64.c
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


