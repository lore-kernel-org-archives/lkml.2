Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757754Ab2CNXMA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 19:12:00 -0400
Received: from outmail008.snc4.facebook.com ([66.220.144.142]:49844 "EHLO
	intmgw002.snc4.facebook.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754415Ab2CNXL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 19:11:59 -0400
Date: Wed, 14 Mar 2012 16:11:54 -0700
From: Arun Sharma <asharma@fb.com>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@gmail.com>,
        Arun Sharma <asharma@fb.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        dsahern@gmail.com, ravitillo@lbl.gov, khandual@linux.vnet.ibm.com,
        robert.richter@amd.com, ming.m.lin@intel.com, vweaver1@eecs.utk.edu,
        andi@firstfloor.org
Subject: Re: [RFC] perf report: Implement symbol filtering on TUI
Message-ID: <20120314231154.GA15986@dev3310.snc6.facebook.com>
References: <20120306062546.GA622@elte.hu>
 <1331085470-32594-1-git-send-email-namhyung.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331085470-32594-1-git-send-email-namhyung.kim@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 10:57:50AM +0900, Namhyung Kim wrote:
> As Ingo requested, symbol filtering feature was missing on TUI.
> Add 's' key to get input from user, and do simple filtering by
> strstr(). To turn filtering off, just enter no name by pressing
> 's' followed by ENTER.

Why not do this for --stdio as well?

perf report foo -g graph,0.5,caller -s inclusive --stdio

will print only the callgraph under foo.

This works better for me than:

perf report -s parent -p ^c$ --stdio

 -Arun

index 94394f3..607b21b 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -219,6 +219,8 @@ static int perf_evlist__tty_browse_hists(struct perf_evlist *evlist,
 		struct hists *hists = &pos->hists;
 		const char *evname = event_name(pos);
 
+		hists->symbol_filter_str = rep->symbol_filter_str;
+		hists__filter_by_symbol(hists);
 		hists__fprintf_nr_sample_events(hists, evname, stdout);
 		hists__fprintf(hists, NULL, false, true, 0, 0, stdout);
 		fprintf(stdout, "\n\n");


