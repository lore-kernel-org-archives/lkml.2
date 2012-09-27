Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab2I0C6k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 22:58:40 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:49535 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab2I0C6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 22:58:38 -0400
X-AuditID: 9c930197-b7b6dae000000e70-1f-5063bbe30cb1
From: Hyeoncheol Lee <hyc.lee@gmail.com>
To: acme@ghostprotocols.net
Cc: LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH] perf probe: print an enum type variable in "enum variable-name" format when showing accessible variables
Date: Thu, 27 Sep 2012 11:36:39 +0900
Message-Id: <1348713399-4541-1-git-send-email-hyc.lee@gmail.com>
X-Mailer: git-send-email 1.7.10.4
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When showing accessible variables, an enum type variable was
 printed in "variable-name" format. Change this format into
"enum variable-name".

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Hyeoncheol Lee <hyc.lee@gmail.com>
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
1.7.10.4

