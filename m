Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920Ab0FOAzW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 20:55:22 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38196 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754970Ab0FOAzV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 20:55:21 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Andy Whitcroft <apw@canonical.com>, linux-doc@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <1276514142.14011.329.camel@localhost>
References: <1276513297-23306-1-git-send-email-apw@canonical.com>
	 <1276514142.14011.329.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 15 Jun 2010 01:55:14 +0100
Message-ID: <1276563314.14011.361.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH] docbook: need xmldoclinks for all doc types
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Whitcroft wrote:
> We need the xmldoclinks built for any document types built from the
> XML sources.

Indeed we do.  So make the XML files depend on xmldoclinks.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Acked-by: Andy Whitcroft <apw@canonical.com>
---
--- a/Documentation/DocBook/Makefile
+++ b/Documentation/DocBook/Makefile
@@ -35,7 +35,7 @@ PS_METHOD	= $(prefer-db2x)
 PHONY += xmldocs sgmldocs psdocs pdfdocs htmldocs mandocs installmandocs cleandocs xmldoclinks
 
 BOOKS := $(addprefix $(obj)/,$(DOCBOOKS))
-xmldocs: $(BOOKS) xmldoclinks
+xmldocs: $(BOOKS)
 sgmldocs: xmldocs
 
 PS := $(patsubst %.xml, %.ps, $(BOOKS))
@@ -95,7 +95,7 @@ define rule_docproc
         ) > $(dir $@).$(notdir $@).cmd
 endef
 
-%.xml: %.tmpl FORCE
+%.xml: %.tmpl xmldoclinks FORCE
 	$(call if_changed_rule,docproc)
 
 ###

-- 
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.
