Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397Ab0LMHX2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 02:23:28 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:60071 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932160Ab0LMHX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 02:23:27 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 13 Dec 2010 08:23:00 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: linux1394-devel@lists.sourceforge.net
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Clemens Ladisch <clemens@ladisch.de>
Subject: [PATCH] firewire: ohci: fix build failure
Message-ID: <20101213082300.122b7152@stein>
In-Reply-To: <20101213154444.eba34b5d.sfr@canb.auug.org.au>
References: <20101213154444.eba34b5d.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vm_map_ram() needs <linux/vmalloc.h>.
(And bring the includes back into alphabetical order.)

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/ohci.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: b/drivers/firewire/ohci.c
===================================================================
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -18,6 +18,7 @@
  * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
+#include <linux/bitops.h>
 #include <linux/bug.h>
 #include <linux/compiler.h>
 #include <linux/delay.h>
@@ -40,7 +41,7 @@
 #include <linux/spinlock.h>
 #include <linux/string.h>
 #include <linux/time.h>
-#include <linux/bitops.h>
+#include <linux/vmalloc.h>
 
 #include <asm/byteorder.h>
 #include <asm/page.h>


-- 
Stefan Richter
-=====-==-=- ==-- -==-=
http://arcgraph.de/sr/
