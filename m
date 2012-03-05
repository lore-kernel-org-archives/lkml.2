Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008Ab2CEXlt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 18:41:49 -0500
Received: from outmail004.snc4.facebook.com ([66.220.144.138]:65002 "EHLO
	intmgw004.snc4.facebook.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757832Ab2CEXlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 18:41:35 -0500
Date: Mon, 5 Mar 2012 15:41:33 -0800
From: Arun Sharma <asharma@fb.com>
To: Arun Sharma <asharma@fb.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org
Subject: Re: [RFC] Sort inclusive
Message-ID: <20120305234133.GA7420@dev3310.snc6.facebook.com>
References: <20120305221253.GA30250@dev3310.snc6.facebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120305221253.GA30250@dev3310.snc6.facebook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2012 at 02:12:54PM -0800, Arun Sharma wrote:
> 
> commit 29e659f0ca2041f2f1681a0072739165220d7c64
> Author: Arun Sharma <asharma@fb.com>
> Date:   Wed Feb 29 21:40:47 2012 +0000
> 
>     perf: Add a new sort order: SORT_INCLUSIVE

Tiny bug fix for --tui users. h->inclusive should be used only for
total_period computation. Otherwise there will be entries in the UI that
you desperately want to navigate to due to the awesomeness of the
earlier patch, but can't get past the first entry :)

I'll fold this into the next rev.

 -Arun

--- a/util/hist.c
+++ b/util/hist.c
@@ -182,10 +182,11 @@ static struct hist_entry *hist_entry__new(struct hist_entry *template)
 
 static void hists__inc_nr_entries(struct hists *hists, struct hist_entry *h)
 {
-	if (!h->filtered && !h->inclusive) {
+	if (!h->filtered) {
 		hists__calc_col_len(hists, h);
 		++hists->nr_entries;
-		hists->stats.total_period += h->period;
+		if (!h->inclusive)
+			hists->stats.total_period += h->period;
 	}
 }
 
