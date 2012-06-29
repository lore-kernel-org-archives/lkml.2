Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab2F2LWo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 07:22:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33342 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991Ab2F2LWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 07:22:43 -0400
Date: Fri, 29 Jun 2012 12:22:40 +0100
From: Mel Gorman <mgorman@suse.de>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [MMTests] Network performance
Message-ID: <20120629112240.GC14154@suse.de>
References: <20120620113252.GE4011@suse.de>
 <20120629111932.GA14154@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20120629111932.GA14154@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Configuration:	global-dhp__network-performance
Benchmarks:	netperf-udp, netperf-tcp, tbench4

Summary
=======
Some tests look good but netperf-tcp tests show a number of problems.

Benchmark notes
===============

netperf used the TCP_STREAM or UDP_STREAM tests. Server and client were bound
to CPU 0 and 1 respectively. To improve the chances of getting an accurate
reading "-i 50,6 -I 99,1" was specified on the command line.  Personally I
tend to find netperf figures a bit unreliable and can vary depending on the
exact starting conditions. This might be due to the test being run against
localhost or because there is no other machine activity to smooth outliers
related to cache coloring. Suggestions on how to mitigate this are welcome.

tbench was from dbench 4 and ran for 3 minutes.

===========================================================
Machine:	arnold
Result:		http://www.csn.ul.ie/~mel/postings/mmtests-20120424/global-dhp__network-performance/arnold/comparison.html
Arch:		x86
CPUs:		1 socket, 2 threads
Model:		Pentium 4
Disk:		Single Rotary Disk
Status:		Ok, but netperf-tcp has problems
===========================================================

netperf-udp
-----------
For the most part, this looks good. 2.6.34 and 3.2.9 were both bad
kernels for some reason but currently it looks fine. I tend to
find that netperf figures fluctuate easily and t

netperf-tcp
-----------
This is less healthy, it looks like there is a fairly consistent
regression of 2-5%.

tbench4
-------
Some of these tests failed to run and the logs are unclear as to
why but only happened on this machine. It's only now that I noticed.
While results are looking ok now, there were some regressions for
3.0 until 3.2 kernels that might be of concern to -stable users.

==========================================================
Machine:	hydra
Result:		http://www.csn.ul.ie/~mel/postings/mmtests-20120424/global-dhp__io-metadata-ext3/hydra/comparison.html
Arch:		x86-64
CPUs:		1 socket, 4 threads
Model:		AMD Phenom II X4 940
Disk:		Single Rotary Disk
Status:		Ok, but netperf-tcp has problems
==========================================================

netperf-udp
-----------
This is looking great. There was a high in 3.1 that has been
lost since but it's still better overall in comparison to
2.6.32.

netperf-tcp
-----------
This is less healthy with a lot of regression. 3.4 has mostly
regressed to the tune of 2-13% versus 2.6.32.

tbench4
-------
For the most part, this is looking ok. 2 clients seems to be
particularly problematic for some reason but otherwise looks
good.

==========================================================
Machine:	sandy
Result:		http://www.csn.ul.ie/~mel/postings/mmtests-20120424/global-dhp__io-metadata-ext3/sandy/comparison.html
Arch:		x86-64
CPUs:		1 socket, 8 threads
Model:		Intel Core i7-2600
Disk:		Single Rotary Disk
Status:		Bad, tbench is ok just otherwise poor
==========================================================

netperf-udp
-----------
This is not a happy story. There was a big drop between 3.2 and 3.3
and the regression is still there in comparison to 2.6.32

netperf-tcp
-----------
This has consistently regressed since 2.6.34 with the regression very
roughly around the 10% mark.

tbench4
-------
Unlike the other tests, this is looking reasonably good with performance
gains until the number of clients gets really high. It was interesting
to note that 2.6.34 was a particularly good kernel for tbench and
while current kernels are better then 2.6.32, they are not as good as
2.6.34.

-- 
Mel Gorman
SUSE Labs
