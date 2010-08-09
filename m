Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271Ab0HIXbi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 19:31:38 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:25372 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757140Ab0HIXbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 19:31:37 -0400
Date: Mon, 9 Aug 2010 16:30:40 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>,
        torvalds <torvalds@linux-foundation.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] docbook: fixup media support files for htmldocs also
Message-Id: <20100809163040.137c6571.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

'make htmldocs' produces errors due to missing a supporting media
file, so add 'xmldoclinks' to the htmldocs dependencies so that the
needed supporting file will be present.

linux-2.6.35-git8/DOC1/Documentation/DocBook/media.xml:4: warning: failed to load external entity "linux-2.6.35-git8/DOC1/Documentation/DocBook/media-entities.tmpl"

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc:	Mauro Carvalho Chehab <mchehab@infradead.org>
---
 Documentation/DocBook/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.35-git8.orig/Documentation/DocBook/Makefile
+++ linux-2.6.35-git8/Documentation/DocBook/Makefile
@@ -45,7 +45,7 @@ PDF := $(patsubst %.xml, %.pdf, $(BOOKS)
 pdfdocs: $(PDF)
 
 HTML := $(sort $(patsubst %.xml, %.html, $(BOOKS)))
-htmldocs: $(HTML)
+htmldocs: $(HTML) xmldoclinks
 	$(call build_main_index)
 	$(call build_images)
 
---
