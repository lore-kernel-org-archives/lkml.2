Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759102Ab1JFTFb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 15:05:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47126 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758996Ab1JFTFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 15:05:30 -0400
Date: Thu, 6 Oct 2011 15:05:27 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: RFC: virtualbox tainting.
Message-ID: <20111006190526.GA13883@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The number of bug reports we get from people with virtualbox loaded are
truly astonishing.  It's GPL, but sadly that doesn't mean it's good.
Nearly all of these bugs look like random corruption. (corrupt linked lists,
corrupt page tables, and just plain 'weird' crashes).

This diff adds tainting to the module loader to treat it as we do with stuff
from staging/ (crap). With this tainting in place, automatic bug filing tools
can opt out of automatically filing kernel bugs, and inform the user to file
bugs somewhere more appropriate.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/kernel/module.c b/kernel/module.c
index 04379f92..d26c9a3 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2653,6 +2653,10 @@ static int check_module_license_and_versions(struct module *mod)
 	if (strcmp(mod->name, "ndiswrapper") == 0)
 		add_taint(TAINT_PROPRIETARY_MODULE);
 
+	/* vbox is garbage. */
+	if (strcmp(mod->name, "vboxdrv") == 0)
+		add_taint(TAINT_CRAP);
+
 	/* driverloader was caught wrongly pretending to be under GPL */
 	if (strcmp(mod->name, "driverloader") == 0)
 		add_taint_module(mod, TAINT_PROPRIETARY_MODULE);
