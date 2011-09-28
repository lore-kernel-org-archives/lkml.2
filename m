Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187Ab1I1WkL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:40:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53750 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932119Ab1I1WkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:40:07 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:28 2011
Message-Id: <20110928220128.831286381@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 14:59:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "John P. Stanley" <jpsinthemix@verizon.net>
Subject: [034/244] savagedb: Fix typo causing regression in savage4 series video chip detection
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: John Stanley <jpsinthemix@verizon.net>

commit 4b00e4b3940eabb38adeec0823751820fe2d6fda upstream.

Two additional savage4 variants were added, but the S3_SAVAGE4_SERIES
macro was incompletely modified, resulting in a false positive detection
of a savage4 card regardless of which savage card is actually present.

For non-savage4 series cards, such as a Savage/IX-MV card, this results
in garbled video and/or a hard-hang at boot time.  Fix this by changing
an '||' to an '&&' in the S3_SAVAGE4_SERIES macro.

Signed-off-by: John P. Stanley <jpsinthemix@verizon.net>
Reviewed-by: Tormod Volden <debian.tormod@gmail.com>
[ The macros have incomplete parenthesis too, but whatever ..  -Linus ]
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/video/savage/savagefb.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/video/savage/savagefb.h
+++ b/drivers/video/savage/savagefb.h
@@ -55,7 +55,7 @@
 
 #define S3_SAVAGE3D_SERIES(chip)  ((chip>=S3_SAVAGE3D) && (chip<=S3_SAVAGE_MX))
 
-#define S3_SAVAGE4_SERIES(chip)   ((chip>=S3_SAVAGE4) || (chip<=S3_PROSAVAGEDDR))
+#define S3_SAVAGE4_SERIES(chip)   ((chip>=S3_SAVAGE4) && (chip<=S3_PROSAVAGEDDR))
 
 #define S3_SAVAGE_MOBILE_SERIES(chip)  ((chip==S3_SAVAGE_MX) || (chip==S3_SUPERSAVAGE))
 


