Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab1EQCO1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 22:14:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:61162 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976Ab1EQCOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 22:14:25 -0400
X-Authority-Analysis: v=1.1 cv=ou1QuR4lBR9YeJgEH9ccYmbAdaWqVVq3lOvCKJtMpGM= c=1 sm=0 a=vhdKIqpQuCYA:10 a=Gm-2C9Kd_5EA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=DBC4KpddjrjLV2-bSYYA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110517021423.661004726@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 16 May 2011 22:10:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC][PATCH 2/2] ftrace/kbuild: Add recordmcount files to force full build
References: <20110517021027.390391519@goodmis.org>
Content-Disposition: inline; filename=0002-ftrace-kbuild-Add-recordmcount-files-to-force-full-b.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Modifications to recordmcount must be performed on all object
files to stay consistent with what the kernel code may expect.
Add the recordmcount files to the force-deps to make sure
any change to them causes a full recompile.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/Makefile.build |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 0ff5a58..057d6e9 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -252,6 +252,7 @@ sub_cmd_record_mcount =					\
 	if [ $(@) != "scripts/mod/empty.o" ]; then	\
 		$(objtree)/scripts/recordmcount "$(@)";	\
 	fi;
+force-deps += $(srctree)/scripts/recordmcount.c $(srctree)/scripts/recordmcount.h
 else
 sub_cmd_record_mcount = set -e ; perl $(srctree)/scripts/recordmcount.pl "$(ARCH)" \
 	"$(if $(CONFIG_CPU_BIG_ENDIAN),big,little)" \
@@ -259,6 +260,7 @@ sub_cmd_record_mcount = set -e ; perl $(srctree)/scripts/recordmcount.pl "$(ARCH
 	"$(OBJDUMP)" "$(OBJCOPY)" "$(CC) $(KBUILD_CFLAGS)" \
 	"$(LD)" "$(NM)" "$(RM)" "$(MV)" \
 	"$(if $(part-of-module),1,0)" "$(@)";
+force-deps += $(srctree)/scripts/recordmcount.pl
 endif
 cmd_record_mcount = 						\
 	if [ "$(findstring -pg,$(_c_flags))" = "-pg" ]; then	\
-- 
1.7.2.3


