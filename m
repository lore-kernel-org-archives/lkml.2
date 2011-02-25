Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679Ab1BYAOn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 19:14:43 -0500
Received: from relay2.sgi.com ([192.48.179.30]:33198 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756632Ab1BYAOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 19:14:42 -0500
To: linux-kernel@vger.kernel.org
Subject: [RFC] Performance Events 'Samples' report
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu,
        acme@ghostprotocols.net
Message-Id: <E1PslLC-0000rj-EF@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Thu, 24 Feb 2011 18:15:26 -0600
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Wickman <cpw@sgi.com>

The perf command's report prints clock periods under the heading of 'Samples'.
Our applications people have been confused by this "Samples" heading.

perf report -n

# Overhead  Samples            Command         Shared Object                            Symbol
# ........ ..........  ...............  ....................  ................................
#
    99.41%1522136216246         pthreads  pthreads              [.] work_function
     0.33% 4980298302             perf  [kernel.kallsyms]     [k] clear_page_c
     ....

It would be more compact to print the number of samples.  And that would
be consistent with the heading.

Below is the code that displays the periods.  I don't see that the number
of samples is available here, but probably easily could be.
I presume that clock periods are derived from #samples * sample period.

perf/util/hist.c

 640 
 641         if (symbol_conf.show_nr_samples) {
 642                 if (sep)
 643                         ret += snprintf(s + ret, size - ret, "%c%" PRIu64,      *sep, period);
 644                 else
 645                         ret += snprintf(s + ret, size - ret, "%11" PRIu64,      period);
 646         }
 647 

Signed-off-by: Cliff Wickman <cpw@sgi.com>

