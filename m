Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758640Ab2I1Qj3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 12:39:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42090 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757572Ab2I1Qj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 12:39:28 -0400
Date: Fri, 28 Sep 2012 09:39:12 -0700
From: tip-bot for Hyeoncheol Lee <hyc.lee@gmail.com>
Message-ID: <tip-bb2d17a014914b628df42b0c76c85fa8a8c57e79@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, masami.hiramatsu.pt@hitachi.com, hyc.lee@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, hyc.lee@gmail.com, masami.hiramatsu.pt@hitachi.com,
        tglx@linutronix.de
In-Reply-To: <1348713399-4541-1-git-send-email-hyc.lee@gmail.com>
References: <1348713399-4541-1-git-send-email-hyc.lee@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Print an enum type variable in "
 enum variable-name" format when showing accessible variables
Git-Commit-ID: bb2d17a014914b628df42b0c76c85fa8a8c57e79
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 28 Sep 2012 09:39:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bb2d17a014914b628df42b0c76c85fa8a8c57e79
Gitweb:     http://git.kernel.org/tip/bb2d17a014914b628df42b0c76c85fa8a8c57e79
Author:     Hyeoncheol Lee <hyc.lee@gmail.com>
AuthorDate: Thu, 27 Sep 2012 11:36:39 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 27 Sep 2012 10:58:57 -0300

perf probe: Print an enum type variable in "enum variable-name" format when showing accessible variables

When showing accessible variables, an enum type variable was printed in
"variable-name" format. Change this format into "enum variable-name".

Signed-off-by: Hyeoncheol Lee <hyc.lee@gmail.com>
Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Link: http://lkml.kernel.org/r/1348713399-4541-1-git-send-email-hyc.lee@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/dwarf-aux.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

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
