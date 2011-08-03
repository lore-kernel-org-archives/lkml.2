Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226Ab1HCK3Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 06:29:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34273 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753792Ab1HCK3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 06:29:07 -0400
Date: Wed, 3 Aug 2011 18:28:59 +0800
From: Han Pingtian <phan@redhat.com>
To: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, jolsa@redhat.com
Subject: perf complains losting events
Message-ID: <20110803102858.GB2790@hpt.nay.redhat.com>
Mail-Followup-To: linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>, jolsa@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I find there is a comment about losting events:

/*
 * The kernel collects the number of events it couldn't send in a stretch and
 * when possible sends this number in a PERF_RECORD_LOST event. The number of
 * such "chunks" of lost events is stored in .nr_events[PERF_EVENT_LOST] while
 * total_lost tells exactly how many events the kernel in fact lost, i.e. it is
 * the sum of all struct lost_event.lost fields reported.
 *
 * The total_period is needed because by default auto-freq is used, so
 * multipling nr_events[PERF_EVENT_SAMPLE] by a frequency isn't possible to get
 * the total number of low level events, it is necessary to to sum all struct
 * sample_event.period and stash the result in total_period.
 */

So my question is, whether the losting of events is a problem? 
I have saw it many times:

[root@hp-dl580g7-01 perf]# ./perf kmem record sleep 1
[ perf record: Woken up 0 times to write data ]
[ perf record: Captured and wrote 21.789 MB perf.data (~951977 samples)
]
Processed 0 events and LOST 76148!

Check IO/CPU overload!

[root@hp-dl580g7-01 perf]# ./perf kmem stat
Processed 0 events and LOST 76148!

Check IO/CPU overload!


SUMMARY
=======
Total bytes requested: 5725028
Total bytes allocated: 6291512
Total bytes wasted on internal fragmentation: 566484
Internal fragmentation: 9.003941%
Cross CPU allocations: 28/84295

-- 
Han Pingtian
Quality Engineer
hpt @ #kernel-qe
Red Hat, Inc
Freedom ... courage ... Commitment ... ACCOUNTABILITY
