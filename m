Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759129Ab1DNPpA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 11:45:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:40585 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620Ab1DNPo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 11:44:58 -0400
Subject: Re: [tip:perf/core] perf evsel: Fix inverted test for fixing up
 attr.inherit flag
From: Peter Zijlstra <peterz@infradead.org>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, eranian@google.com,
        linux-kernel@vger.kernel.org, tzanussi@gmail.com, efault@gmx.de,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        mingo@elte.hu, linux-tip-commits@vger.kernel.org
In-Reply-To: <20110411173536.GA29895@ghostprotocols.net>
References: <new-submission>
	 <tip-e603dc15072c7fec0ae263597e6dabc3bb4c5c5b@git.kernel.org>
	 <1302357942.9086.1281.camel@twins>
	 <20110411173536.GA29895@ghostprotocols.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Apr 2011 17:47:26 +0200
Message-ID: <1302796046.2035.28.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-11 at 14:35 -0300, Arnaldo Carvalho de Melo wrote:
> 
> Can you check if the patch below fixes this? An acked-by or tested-by
> tag would be mucho appreciated.
> 

Didn't work..

# ./perf stat ~/loop_1b_instructions-4x

 Performance counter stats for '/root/loop_1b_instructions-4x':

        288.908743 task-clock-msecs         #      0.444 CPUs 
                51 context-switches         #      0.000 M/sec
                 1 CPU-migrations           #      0.000 M/sec
               116 page-faults              #      0.000 M/sec
       715,288,186 cycles                   #   2475.827 M/sec  (scaled from 49.77%)
     1,000,703,570 instructions             #      1.399 IPC    (scaled from 64.61%)
       100,255,005 branches                 #    347.013 M/sec  (scaled from 56.19%)
            11,453 branch-misses            #      0.011 %      (scaled from 65.27%)
            26,089 cache-references         #      0.090 M/sec  (scaled from 43.82%)
               110 cache-misses             #      0.000 M/sec  (scaled from 36.35%)

        0.649991199  seconds time elapsed

That wants to have 4b insn

---

#include <stdlib.h>
#include <stdio.h>
#include <time.h>

main ()
{
	int i;

	fork();
	fork();

	for (i = 0; i < 100000000; i++) {
		asm("nop");
		asm("nop");
		asm("nop");
		asm("nop");
		asm("nop");
		asm("nop");
		asm("nop");
	}
	wait(NULL);
	wait(NULL);
	wait(NULL);
	wait(NULL);
}


