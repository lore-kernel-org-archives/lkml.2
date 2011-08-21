Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932194Ab1HUW7m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 18:59:42 -0400
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:53061 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932077Ab1HUW7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 18:59:39 -0400
From: Joe Perches <joe@perches.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Olivier Lorin <o.lorin@laposte.net>
Cc: Jean-Francois Moine <moinejf@free.fr>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 08/14] [media] gl860: Use current logging styles
Date: Sun, 21 Aug 2011 15:56:51 -0700
Message-Id: <82f14089032b403856a5306b5e53749897240c15.1313966090.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
In-Reply-To: <cover.1313966088.git.joe@perches.com>
References: <cover.1313966088.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add pr_fmt.
Convert err macro use to pr_err.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/media/video/gspca/gl860/gl860.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/gspca/gl860/gl860.c b/drivers/media/video/gspca/gl860/gl860.c
index e8e071a..2ced3b7 100644
--- a/drivers/media/video/gspca/gl860/gl860.c
+++ b/drivers/media/video/gspca/gl860/gl860.c
@@ -18,6 +18,9 @@
  * You should have received a copy of the GNU General Public License
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include "gspca.h"
 #include "gl860.h"
 
@@ -572,9 +575,8 @@ int gl860_RTx(struct gspca_dev *gspca_dev,
 	}
 
 	if (r < 0)
-		err("ctrl transfer failed %4d "
-			"[p%02x r%d v%04x i%04x len%d]",
-			r, pref, req, val, index, len);
+		pr_err("ctrl transfer failed %4d [p%02x r%d v%04x i%04x len%d]\n",
+		       r, pref, req, val, index, len);
 	else if (len > 1 && r < len)
 		PDEBUG(D_ERR, "short ctrl transfer %d/%d", r, len);
 
-- 
1.7.6.405.gc1be0

