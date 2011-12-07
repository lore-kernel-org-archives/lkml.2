Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103Ab1LGQt2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:49:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33676 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757703Ab1LGQUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:20:37 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:12:15 2011
Message-Id: <20111207161215.916295296@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:11:16 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Daniel Drake <dsd@laptop.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [014/104] viafb: correct sync polarity for OLPC DCON
In-Reply-To: <20111207161246.GA10995@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Drake <dsd@laptop.org>

commit a32839696a8eef813a1aff604fbad9a32dff6c95 upstream.

While the OLPC display appears to be able to handle either positive
or negative sync, the Display Controller only recognises positive sync.

This brings viafb (for XO-1.5) in line with lxfb (for XO-1) and
fixes a recent regression where the XO-1.5 DCON could no longer be
frozen. Thanks to Florian Tobias Schandinat for helping identify
the fix.

Test case: from a vt,
	echo 1 > /sys/devices/platform/dcon/freeze
should cause the current screen contents to freeze, rather than garbage being
displayed.

Signed-off-by: Daniel Drake <dsd@laptop.org>
Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/video/via/share.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/video/via/share.h
+++ b/drivers/video/via/share.h
@@ -557,8 +557,8 @@
 #define M1200X720_R60_VSP       POSITIVE
 
 /* 1200x900@60 Sync Polarity (DCON) */
-#define M1200X900_R60_HSP       NEGATIVE
-#define M1200X900_R60_VSP       NEGATIVE
+#define M1200X900_R60_HSP       POSITIVE
+#define M1200X900_R60_VSP       POSITIVE
 
 /* 1280x600@60 Sync Polarity (GTF Mode) */
 #define M1280x600_R60_HSP       NEGATIVE


