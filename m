Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052Ab2CHH3U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 02:29:20 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53293 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487Ab2CHH3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 02:29:17 -0500
Date: Thu, 8 Mar 2012 08:29:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arun Sharma <asharma@fb.com>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Tom Zanussi <tzanussi@gmail.com>,
        linux-perf-users@vger.kernel.org
Subject: Re: [PATCH 0/2] perf: add sort by inclusive time functionality (v2)
Message-ID: <20120308072901.GC20784@elte.hu>
References: <1331160079-13821-1-git-send-email-asharma@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331160079-13821-1-git-send-email-asharma@fb.com>
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


* Arun Sharma <asharma@fb.com> wrote:

> This patch series refactors existing code a bit and adds sort by 
> inclusive time (time spent in the function + callees).
> 
> Sample command lines:
> 
> # perf record -ag -- sleep 1
> # perf report -g graph,0.5,callee -n -s inclusive

So I tried this out with:

  $ taskset 1 perf record -g git gc

and got entries above 100% (in the TUI):

  $ perf report -g graph,0.5,callee -n -s inclusive

 +  321.11%        5628  [.] 0x392b609269
 +  142.27%        3774  [.] create_delta
 +  78.86%        1248  [.] lookup_object
 +  40.54%        1348  [k] system_call_fastpath
 [...]

Is that expected?

Thanks,

	Ingo
