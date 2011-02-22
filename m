Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988Ab1BVWVX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:21:23 -0500
Received: from kroah.org ([198.145.64.141]:46615 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753814Ab1BVWVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:21:21 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 22 14:18:38 2011
Message-Id: <20110222221838.567882669@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 22 Feb 2011 14:16:54 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Thomas Renninger <trenn@suse.de>,
        Arjan van de Ven <arjan@linux.intel.com>, Jean Pihet <j-pihet@ti.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: [15/70] perf timechart: Adjust perf timechart to the new power events
In-Reply-To: <20110222222003.GA15831@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Thomas Renninger <trenn@suse.de>

commit 20c457b8587bee4644d998331d9e13be82e05b4c upstream.

[This patch is part of mainline git commit 20c457b8587bee4644d9.
  This should fix:
  http://www.mail-archive.com/linux-perf-users@vger.kernel.org/msg00057.html

  The regression was introduced by git commit:
  4c21adf26f8fcf86a755b9b9f55c2e9fd241e1fb]

builtin-timechart must only pass -e power:xy events if they are supported by
the running kernel, otherwise try to fetch the old power:power{start,end}
events.

For this I added the tiny helper function:

   int is_valid_tracepoint(const char *event_string)

to parse-events.[hc], which could be more generic as an interface and support
hardware/software/... events, not only tracepoints, but someone else could
extend that if needed...

Signed-off-by: Thomas Renninger <trenn@suse.de>
Acked-by: Arjan van de Ven <arjan@linux.intel.com>
Acked-by: Jean Pihet <j-pihet@ti.com>
LKML-Reference: <1294073445-14812-4-git-send-email-trenn@suse.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 tools/perf/builtin-timechart.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -502,7 +502,7 @@ static int process_sample_event(event_t
 			c_state_start(pe->cpu_id, data.time, pe->value);
 
 		if (strcmp(event_str, "power:power_end") == 0)
-			c_state_end(pe->cpu_id, data.time);
+			c_state_end(data.cpu, data.time);
 
 		if (strcmp(event_str, "power:power_frequency") == 0)
 			p_state_change(pe->cpu_id, data.time, pe->value);


