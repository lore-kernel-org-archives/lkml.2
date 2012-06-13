Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106Ab2FMInr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 04:43:47 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:35162 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207Ab2FMInp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 04:43:45 -0400
Message-ID: <1339577020.4519.19.camel@jlt3.sipsolutions.net>
Subject: [PATCH] Documentation: fix DOCBOOKS=... building
From: Johannes Berg <johannes@sipsolutions.net>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Wed, 13 Jun 2012 10:43:40 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Prior to 
commit 4266129964b8238526936d723de65b419d8069c6
Author: Mauro Carvalho Chehab <mchehab@redhat.com>
Date:   Tue May 31 16:27:44 2011 -0300

    [media] DocBook: Move all media docbook stuff into its own directory

it was possible to build only a single (or more)
book(s) by calling, for example
	make htmldocs DOCBOOKS=80211.xml

This now fails:
cp: target `.../Documentation/DocBook//media_api' is not a directory

Ignore errors from that copy to make this possible again.

Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
I complained about this a long time ago, but now it finally bothered me
enough to fix it ... :-)

 Documentation/DocBook/media/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/DocBook/media/Makefile	2012-06-13 10:39:58.000000000 +0200
+++ b/Documentation/DocBook/media/Makefile	2012-06-13 10:40:05.000000000 +0200
@@ -195,7 +195,7 @@ DVB_DOCUMENTED = \
 #
 
 install_media_images = \
-	$(Q)cp $(OBJIMGFILES) $(MEDIA_SRC_DIR)/v4l/*.svg $(MEDIA_OBJ_DIR)/media_api
+	$(Q)-cp $(OBJIMGFILES) $(MEDIA_SRC_DIR)/v4l/*.svg $(MEDIA_OBJ_DIR)/media_api
 
 $(MEDIA_OBJ_DIR)/%: $(MEDIA_SRC_DIR)/%.b64
 	$(Q)base64 -d $< >$@


