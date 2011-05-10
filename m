Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876Ab1EJSxR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 14:53:17 -0400
Received: from outmail021.snc4.facebook.com ([66.220.144.153]:60544 "EHLO
	mx-out.facebook.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750863Ab1EJSxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 14:53:15 -0400
From: Arun Sharma <asharma@fb.com>
To: linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        acme@ghostprotocols.net
Cc: Arun Sharma <asharma@fb.com>
Subject: [PATCH] Add dso->deleted bit
Date: Tue, 10 May 2011 11:51:47 -0700
Message-Id: <1305053507-28729-1-git-send-email-asharma@fb.com>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This keeps the knowledge about deleted filenames in one place.

Signed-off-by: Arun Sharma <asharma@fb.com>
---
 tools/perf/util/map.c    |    1 +
 tools/perf/util/symbol.c |    2 +-
 tools/perf/util/symbol.h |    1 +
 3 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index a16ecab..042ba9f 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -135,6 +135,7 @@ int map__load(struct map *self, symbol_filter_t filter)
 				   "a debug package?\n", name);
 		}
 
+		self->dso->deleted = 1;
 		return -1;
 	}
 	/*
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 17df793..dbd1944 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1575,7 +1575,7 @@ restart:
 	}
 
 	free(name);
-	if (ret < 0 && strstr(self->name, " (deleted)") != NULL)
+	if (ret < 0 && self->deleted)
 		return 0;
 	return ret;
 }
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 713b0b4..943a054 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -142,6 +142,7 @@ struct dso {
 	u8		 annotate_warned:1;
 	u8		 sname_alloc:1;
 	u8		 lname_alloc:1;
+	u8		 deleted:1;
 	unsigned char	 symtab_type;
 	u8		 sorted_by_name;
 	u8		 loaded;
-- 
1.7.4

