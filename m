Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757606Ab2LHBlr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 20:41:47 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:45109 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757547Ab2LHBlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 20:41:46 -0500
From: Cong Ding <dinggnu@gmail.com>
To: Alan Cox <alan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Cong Ding <dinggnu@gmail.com>
Subject: [PATCH 1/2] tty: remove trailing spaces in tty/hvc
Date: Sat,  8 Dec 2012 01:41:23 +0000
Message-Id: <1354930884-20913-1-git-send-email-dinggnu@gmail.com>
X-Mailer: git-send-email 1.7.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove trailing blank spaces in tty/hvc by shell command:
sed 's/\s\+$//g' -i

I have manually reviewed that everything is correct.

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 drivers/tty/hvc/hvc_console.c |    6 +++---
 drivers/tty/hvc/hvc_xen.c     |    2 +-
 drivers/tty/hvc/hvcs.c        |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/hvc/hvc_console.c b/drivers/tty/hvc/hvc_console.c
index 13ee53b..088fdfc 100644
--- a/drivers/tty/hvc/hvc_console.c
+++ b/drivers/tty/hvc/hvc_console.c
@@ -11,12 +11,12 @@
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
- * 
+ *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- * 
+ *
  * You should have received a copy of the GNU General Public License
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
@@ -187,7 +187,7 @@ static struct tty_driver *hvc_console_device(struct console *c, int *index)
 }
 
 static int __init hvc_console_setup(struct console *co, char *options)
-{	
+{
 	if (co->index < 0 || co->index >= MAX_NR_HVC_CONSOLES)
 		return -ENODEV;
 
diff --git a/drivers/tty/hvc/hvc_xen.c b/drivers/tty/hvc/hvc_xen.c
index 19843ec..c598d55 100644
--- a/drivers/tty/hvc/hvc_xen.c
+++ b/drivers/tty/hvc/hvc_xen.c
@@ -126,7 +126,7 @@ static int domU_write_console(uint32_t vtermno, const char *data, int len)
 	 */
 	while (len) {
 		int sent = __write_console(cons, data, len);
-		
+
 		data += sent;
 		len -= sent;
 
diff --git a/drivers/tty/hvc/hvcs.c b/drivers/tty/hvc/hvcs.c
index 8776357..5f5ddf5 100644
--- a/drivers/tty/hvc/hvcs.c
+++ b/drivers/tty/hvc/hvcs.c
@@ -166,8 +166,8 @@ MODULE_VERSION(HVCS_DRIVER_VERSION);
 /*
  * The hcall interface involves putting 8 chars into each of two registers.
  * We load up those 2 registers (in arch/powerpc/platforms/pseries/hvconsole.c)
- * by casting char[16] to long[2].  It would work without __ALIGNED__, but a 
- * little (tiny) bit slower because an unaligned load is slower than aligned 
+ * by casting char[16] to long[2].  It would work without __ALIGNED__, but a
+ * little (tiny) bit slower because an unaligned load is slower than aligned
  * load.
  */
 #define __ALIGNED__	__attribute__((__aligned__(8)))
-- 
1.7.4.5

