Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab1G2XTw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 19:19:52 -0400
Received: from smtp-out.google.com ([216.239.44.51]:62769 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146Ab1G2XTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 19:19:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:to:cc:subject:message-id:
	mime-version:content-type:content-disposition:user-agent:x-system-of-record;
	b=dfpfTN3QWrcLgomKHYyvEXHmkuEU3+8w2ieAUQTBoacDCUnlnoLMPO0ylMaD9yI03
	kISmF3Uiuk/O1LUc7yHSA==
Date: Sat, 30 Jul 2011 01:20:40 +0200
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: daahern@cisco.com, acme@redhat.com, mingo@elte.hu, peterz@infradead.org
Subject: [PATCH] perf: add --symfs option to perf annotate
Message-ID: <20110729232040.GA21838@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If you have --symfs in perf report, then you also need it
for perf annotate. This allows off-box assembly level analysis
of perf.data samples.

This patch complements:

commit ec5761eab318e50e69fcf8e63e9edaef5949c067
Author: David Ahern <daahern@cisco.com>
Date:   Thu Dec 9 13:27:07 2010 -0700

    perf symbols: Add symfs option for off-box analysis using specified tree

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/tools/perf/Documentation/perf-annotate.txt b/tools/perf/Documentation/perf-annotate.txt
index 85c5f02..15919dd 100644
--- a/tools/perf/Documentation/perf-annotate.txt
+++ b/tools/perf/Documentation/perf-annotate.txt
@@ -72,6 +72,9 @@ OPTIONS
 	CPUs are specified with -: 0-2. Default is to report samples on all
 	CPUs.
 
+--symfs=<directory>::
+        Look for files with symbols relative to this directory.
+
 SEE ALSO
 --------
 linkperf:perf-record[1], linkperf:perf-report[1]
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 555aefd..1605fbe 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -267,6 +267,8 @@ static const struct option options[] = {
 	OPT_BOOLEAN('P', "full-paths", &full_paths,
 		    "Don't shorten the displayed pathnames"),
 	OPT_STRING('c', "cpu", &cpu_list, "cpu", "list of cpus to profile"),
+	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
+		    "Look for files with symbols relative to this directory"),
 	OPT_END()
 };
 
