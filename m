Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505Ab1JAHxs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 03:53:48 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:44460 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341Ab1JAHxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 03:53:42 -0400
Date: Sat, 1 Oct 2011 09:52:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fix
Message-ID: <20111001075211.GA22625@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://tesla.tglx.de/git/linux-2.6-tip.git perf-urgent-for-linus

 Thanks,

	Ingo

------------------>
Jiri Olsa (1):
      perf tools: Fix raw sample reading


 tools/perf/util/evsel.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index c5748c5..e389815 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -449,6 +449,8 @@ int perf_event__parse_sample(const union perf_event *event, u64 type,
 	}
 
 	if (type & PERF_SAMPLE_RAW) {
+		const u64 *pdata;
+
 		u.val64 = *array;
 		if (WARN_ONCE(swapped,
 			      "Endianness of raw data not corrected!\n")) {
@@ -462,11 +464,12 @@ int perf_event__parse_sample(const union perf_event *event, u64 type,
 			return -EFAULT;
 
 		data->raw_size = u.val32[0];
+		pdata = (void *) array + sizeof(u32);
 
-		if (sample_overlap(event, &u.val32[1], data->raw_size))
+		if (sample_overlap(event, pdata, data->raw_size))
 			return -EFAULT;
 
-		data->raw_data = &u.val32[1];
+		data->raw_data = (void *) pdata;
 	}
 
 	return 0;
