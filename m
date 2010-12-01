Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782Ab0LAIam (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 03:30:42 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51494 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105Ab0LAIal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 03:30:41 -0500
Date: Wed, 1 Dec 2010 09:30:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Julia Lawall <julia@diku.dk>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/2] perf tools: fix event parsing of comma-separated
 tracepoint events
Message-ID: <20101201083001.GB3140@elte.hu>
References: <1291166390-19467-1-git-send-email-acme@infradead.org>
 <1291166390-19467-3-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291166390-19467-3-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> 
> There are number of issues that prevent the use of multiple tracepoint events
> being specified in a -e/--event switch, separated by commas.
> 
> For example, perf stat -e irq:irq_handler_entry,irq:irq_handler_exit ...  fails
> because the tracepoint event parsing code doesn't recognize the comma separator
> properly.
> 
> This patch corrects those issues.

One other thing we seem to have forgotten in the perf stat area: could we please 
make Stephane's --big-num feature the default for perf stat? Big numbers are much 
easier to read that way:

Before:

aldebaran:~> perf stat ./loop_100b_instructions

 Performance counter stats for './loop_100b_instructions':

       23958.911461  task-clock-msecs         #      0.998 CPUs 
                 50  context-switches         #      0.000 M/sec
                  2  CPU-migrations           #      0.000 M/sec
                106  page-faults              #      0.000 M/sec
        76647095433  cycles                   #   3199.106 M/sec
       110471119457  instructions             #      1.441 IPC  
        10116354483  branches                 #    422.238 M/sec
             518642  branch-misses            #      0.005 %    
             220770  cache-references         #      0.009 M/sec
              81657  cache-misses             #      0.003 M/sec

       24.006780937  seconds time elapsed

After:

aldebaran:~> perf stat --big-num ./loop_100b_instructions

 Performance counter stats for './loop_100b_instructions':

       23869.990497  task-clock-msecs         #      0.998 CPUs 
                 58  context-switches         #      0.000 M/sec
                 43  CPU-migrations           #      0.000 M/sec
                106  page-faults              #      0.000 M/sec
     76,338,390,893  cycles                   #   3198.091 M/sec
    110,473,163,060  instructions             #      1.447 IPC  
     10,114,252,456  branches                 #    423.723 M/sec
          1,290,825  branch-misses            #      0.013 %    
          1,713,770  cache-references         #      0.072 M/sec
            188,051  cache-misses             #      0.008 M/sec

       23.917757467  seconds time elapsed

perf stat output isnt an ABI.

(Btw., we should probably also add tabular output for scripts. I thought we had that 
- but apparently not.)

	Ingo
