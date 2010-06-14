Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab0FNLBo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 07:01:44 -0400
Received: from adelie.canonical.com ([91.189.90.139]:45691 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756025Ab0FNLBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 07:01:43 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Randy Dunlap <rdunlap@xenotime.net>, Ben Hutchings <ben@decadent.org.uk>,
       linux-doc@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 1/1] docbook: need xmldoclinks for all doc types
Date: Mon, 14 Jun 2010 12:01:37 +0100
Message-Id: <1276513297-23306-1-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need the xmldoclinks built for any document types built from the
XML sources.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 Documentation/DocBook/Makefile |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/DocBook/Makefile b/Documentation/DocBook/Makefile
index c7e5dc7..f918d4a 100644
--- a/Documentation/DocBook/Makefile
+++ b/Documentation/DocBook/Makefile
@@ -35,17 +35,17 @@ PS_METHOD	= $(prefer-db2x)
 PHONY += xmldocs sgmldocs psdocs pdfdocs htmldocs mandocs installmandocs cleandocs xmldoclinks
 
 BOOKS := $(addprefix $(obj)/,$(DOCBOOKS))
-xmldocs: $(BOOKS) xmldoclinks
+xmldocs: xmldoclinks $(BOOKS)
 sgmldocs: xmldocs
 
 PS := $(patsubst %.xml, %.ps, $(BOOKS))
-psdocs: $(PS)
+psdocs: xmldoclinks $(PS)
 
 PDF := $(patsubst %.xml, %.pdf, $(BOOKS))
-pdfdocs: $(PDF)
+pdfdocs: xmldoclinks $(PDF)
 
 HTML := $(sort $(patsubst %.xml, %.html, $(BOOKS)))
-htmldocs: $(HTML)
+htmldocs: xmldoclinks $(HTML)
 	$(call build_main_index)
 	$(call build_images)
 
-- 
1.7.0.4

