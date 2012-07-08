Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901Ab2GHRfa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 13:35:30 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:33950 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751211Ab2GHRf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 13:35:28 -0400
Date: Sun, 8 Jul 2012 19:34:55 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH v2] kbuild: add a rule to just create one file for kernel doc
Message-ID: <20120708173455.GC2872@breakpoint.cc>
References: <1340732427-3747-1-git-send-email-sebastian@breakpoint.cc>
 <4FEC1E92.5070005@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FEC1E92.5070005@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you are chaning the file and you want to verify that it looks good it
is helpfull to just re-run for the single file instead of running the
complete htmldocs target.

With this patch one can run
|	make drivers/mtd/ubi/wl.html
and create the output just for this file.

Cc: Richard Weinberger <richard@nod.at>
Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
v1..v2:
	- rules moved to Documentation/DocBook/Makefile instead
	  scripts/Makefile.build
	- added html to clean target

 Documentation/DocBook/Makefile |    8 ++++++++
 Makefile                       |    6 +++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/Documentation/DocBook/Makefile b/Documentation/DocBook/Makefile
index bc3d9f8..423adad 100644
--- a/Documentation/DocBook/Makefile
+++ b/Documentation/DocBook/Makefile
@@ -204,6 +204,14 @@ silent_gen_xml = :
 	   echo "</programlisting>")  > $@
 
 ###
+# or HTML documentation
+quiet_cmd_doc_html_c	= HTML $@
+cmd_doc_html_c		= $(KERNELDOC) -html $< > $@
+
+%.html: %.c
+	$(call if_changed,doc_html_c)
+
+###
 # Help targets as used by the top-level makefile
 dochelp:
 	@echo  ' Linux kernel internal documentation in different formats:'
diff --git a/Makefile b/Makefile
index bf02707..96ac5d6 100644
--- a/Makefile
+++ b/Makefile
@@ -1079,6 +1079,7 @@ help:
 	@echo  '  dir/file.lst    - Build specified mixed source/assembly target only'
 	@echo  '                    (requires a recent binutils and recent build (System.map))'
 	@echo  '  dir/file.ko     - Build module including final link'
+	@echo  '  dir/file.html   - Build kernel HTML-doc only for this file'
 	@echo  '  modules_prepare - Set up for building external modules'
 	@echo  '  tags/TAGS	  - Generate tags file for editors'
 	@echo  '  cscope	  - Generate cscope index'
@@ -1154,6 +1155,9 @@ $(help-board-dirs): help-%:
 	$(Q)$(MAKE) $(build)=scripts build_docproc
 	$(Q)$(MAKE) $(build)=Documentation/DocBook $@
 
+%.html: %.c FORCE
+	$(Q)$(MAKE) $(build)=Documentation/DocBook $(target-dir)$(notdir $@)
+
 else # KBUILD_EXTMOD
 
 ###
@@ -1240,7 +1244,7 @@ clean: $(clean-dirs)
 	@find $(if $(KBUILD_EXTMOD), $(KBUILD_EXTMOD), .) $(RCS_FIND_IGNORE) \
 		\( -name '*.[oas]' -o -name '*.ko' -o -name '.*.cmd' \
 		-o -name '.*.d' -o -name '.*.tmp' -o -name '*.mod.c' \
-		-o -name '*.symtypes' -o -name 'modules.order' \
+		-o -name '*.symtypes' -o -name 'modules.order' -o -name *.html \
 		-o -name modules.builtin -o -name '.tmp_*.o.*' \
 		-o -name '*.gcno' \) -type f -print | xargs rm -f
 
-- 
1.7.10.4

