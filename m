Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab0JJPLR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 11:11:17 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45145 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752525Ab0JJPLP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 11:11:15 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1286723403.2955.205.camel@localhost>
References: <1286723403.2955.205.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 10 Oct 2010 16:11:02 +0100
Message-ID: <1286723462.2955.206.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH 2/2] perf: Fix detection of script extension
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The extension starts with the last dot in the name, not the first.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 tools/perf/builtin-trace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 3ea6219..deda1a9 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -282,7 +282,7 @@ static int parse_scriptname(const struct option *opt __used,
 		script++;
 	} else {
 		script = str;
-		ext = strchr(script, '.');
+		ext = strrchr(script, '.');
 		if (!ext) {
 			fprintf(stderr, "invalid script extension");
 			return -1;
-- 
1.7.1


