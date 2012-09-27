Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620Ab2I0VSr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 17:18:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:49037 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755227Ab2I0VSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 17:18:46 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Hyeoncheol Lee <hyc.lee@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/3] perf probe: Print an enum type variable in "enum variable-name" format when showing accessible variables
Date: Thu, 27 Sep 2012 18:18:05 -0300
Message-Id: <1348780686-16108-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1348780686-16108-1-git-send-email-acme@infradead.org>
References: <1348780686-16108-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hyeoncheol Lee <hyc.lee@gmail.com>

When showing accessible variables, an enum type variable was printed in
"variable-name" format. Change this format into "enum variable-name".

Signed-off-by: Hyeoncheol Lee <hyc.lee@gmail.com>
Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Link: http://lkml.kernel.org/r/1348713399-4541-1-git-send-email-hyc.lee@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/dwarf-aux.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/dwarf-aux.c b/tools/perf/util/dwarf-aux.c
index ee51e9b..3e5f543 100644
--- a/tools/perf/util/dwarf-aux.c
+++ b/tools/perf/util/dwarf-aux.c
@@ -804,6 +804,8 @@ int die_get_typename(Dwarf_Die *vr_die, char *buf, int len)
 			tmp = "union ";
 		else if (tag == DW_TAG_structure_type)
 			tmp = "struct ";
+		else if (tag == DW_TAG_enumeration_type)
+			tmp = "enum ";
 		/* Write a base name */
 		ret = snprintf(buf, len, "%s%s", tmp, dwarf_diename(&type));
 		return (ret >= len) ? -E2BIG : ret;
-- 
1.7.9.2.358.g22243

