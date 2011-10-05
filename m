Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935194Ab1JERXX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 13:23:23 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38499 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934962Ab1JERXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 13:23:21 -0400
Subject: [PATCH] devicetree: fix build error on
 drivers/tty/serial/altera_jtaguart.c
To: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
From: Grant Likely <grant.likely@secretlab.ca>
Cc: Tobias Klauser <tklauser@distanz.ch>, Ben Dooks <ben-linux@fluff.org>,
        Alan Cox <alan@linux.intel.com>
Date: Wed, 05 Oct 2011 11:23:16 -0600
Message-ID: <20111005172223.2949.66623.stgit@ponder>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following build error caused by commit
85888069cf5d ("tty: use of_match_ptr() for of_match_table entry").
The problem was a missing #include <linux/of.h> which is where
of_match_ptr() is defined.

drivers/tty/serial/altera_jtaguart.c:483:3: error: implicit declaration of function 'of_match_ptr' [-Werror=implicit-function-declaration]
drivers/tty/serial/altera_jtaguart.c:483:34: error: 'altera_jtaguart_match' undeclared here (not in a function)

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Tobias Klauser <tklauser@distanz.ch> (maintainer:ALTERA UART/JTAG...)
Cc: Alan Cox <alan@linux.intel.com> (maintainer:SERIAL DRIVERS)
---

This fixes a problem in the devicetree/next branch and I've already
committed the change.  I posting it to the list for completeness.

g.

 drivers/tty/serial/altera_jtaguart.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/serial/altera_jtaguart.c b/drivers/tty/serial/altera_jtaguart.c
index 2075200..af46c56 100644
--- a/drivers/tty/serial/altera_jtaguart.c
+++ b/drivers/tty/serial/altera_jtaguart.c
@@ -18,6 +18,7 @@
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/console.h>
+#include <linux/of.h>
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
 #include <linux/serial.h>

