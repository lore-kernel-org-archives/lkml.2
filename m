Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465Ab0JOQOP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 12:14:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:33440 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756382Ab0JOQOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 12:14:11 -0400
X-Authority-Analysis: v=1.1 cv=QISHQ+x4xS+apxgDHgAvNvlUjyrXCzYsHvuXcbPYiKg= c=1 sm=0 a=X4Jpp518rpoA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=0bIBIenkJExowfLqrbsA:9 a=Je-kq4JMU9lsAuwowx6rxlHZxoUA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101015161409.316533201@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 15 Oct 2010 12:13:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org
Subject: [PATCH 2/2] ftrace: Use objtree for C version of recordmcount
References: <20101015161334.766423984@goodmis.org>
Content-Disposition: inline; filename=0002-ftrace-Use-objtree-for-C-version-of-recordmcount.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The C version of recordmcount is compiled to a binary, which will
end up located in the objtree. If the kernel is built with O=path,
the srctree will not include the binary recordmcount caller.

Cc: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/Makefile.build |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 4d03a7e..4db60b2 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -210,7 +210,7 @@ endif
 
 ifdef CONFIG_FTRACE_MCOUNT_RECORD
 ifdef BUILD_C_RECORDMCOUNT
-cmd_record_mcount = $(srctree)/scripts/recordmcount "$(@)";
+cmd_record_mcount = $(objtree)/scripts/recordmcount "$(@)";
 else
 cmd_record_mcount = set -e ; perl $(srctree)/scripts/recordmcount.pl "$(ARCH)" \
 	"$(if $(CONFIG_CPU_BIG_ENDIAN),big,little)" \
-- 
1.7.1


