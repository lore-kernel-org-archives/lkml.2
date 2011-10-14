Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605Ab1JNS2D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 14:28:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:60447 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab1JNS2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 14:28:00 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Thomas Jarosch <thomas.jarosch@intra2net.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5/5] perf buildid: Fix possible unterminated readlink() result buffer
Date: Fri, 14 Oct 2011 15:27:53 -0300
Message-Id: <1318616873-26739-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1318616873-26739-1-git-send-email-acme@infradead.org>
References: <1318616873-26739-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Jarosch <thomas.jarosch@intra2net.com>

The readlink function doesn't guarantee that a '\0' will be put at the
end of the provided buffer if there is no space left.

No need to do "buf[len] = '\0';" since the buffer is allocated with
zalloc().

Link: http://lkml.kernel.org/r/4E986ABF.9040706@intra2net.com
Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index f2ceb0f..2143a32 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1289,7 +1289,7 @@ int build_id_cache__remove_s(const char *sbuild_id, const char *debugdir)
 	if (access(linkname, F_OK))
 		goto out_free;
 
-	if (readlink(linkname, filename, size) < 0)
+	if (readlink(linkname, filename, size - 1) < 0)
 		goto out_free;
 
 	if (unlink(linkname))
-- 
1.6.2.5

