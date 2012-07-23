Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068Ab2GWVZB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 17:25:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54512 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754900Ab2GWVZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 17:25:00 -0400
Date: Mon, 23 Jul 2012 22:24:56 +0100
From: Mel Gorman <mgorman@suse.de>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [MMTests] Threaded IO Performance on ext3
Message-ID: <20120723212455.GI9222@suse.de>
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


Configuration:	global-dhp__io-threaded-ext3
Result: 	http://www.csn.ul.ie/~mel/postings/mmtests-20120424/global-dhp__io-threaded-ext3
Benchmarks:	tiobench

Summary
=======

Some good results but some 3.x kernels were bad and this varied between
machines. In some, 3.1 and 3.2 were particularly bad. 3.4 regressed on
one machine with a large amount of memory.

Benchmark notes
===============

mkfs was run on system startup. No attempt was made to age it. No
special mkfs or mount options were used.

The size parameter for tiobench was 2*RAM. This is barely sufficient for
	this particular test where the size parameter should be multiple
	times the size of memory. The running time of the benchmark is
	already excessive and this is not likely to be changed.

===========================================================
Machine:	arnold
Result:		http://www.csn.ul.ie/~mel/postings/mmtests-20120424/global-dhp__io-threaded-ext3/arnold/comparison.html
Arch:		x86
CPUs:		1 socket, 2 threads
Model:		Pentium 4
Disk:		Single Rotary Disk
==========================================================

tiobench
--------
  This has regressed in almost all cases although for this machine the
  main damage was between 2.6.32 and 2.6.34. 3.2.9 performed particularly
  badly. It's interesting to note that 3.1 and 3.2 kernels both swapped
  and unexpected swapping has been seen in other tests.

==========================================================
Machine:	hydra
Result:		http://www.csn.ul.ie/~mel/postings/mmtests-20120424/global-dhp__io-threaded-ext3/hydra/comparison.html
Arch:		x86-64
CPUs:		1 socket, 4 threads
Model:		AMD Phenom II X4 940
Disk:		Single Rotary Disk
==========================================================

tiobench
--------
  This is a mixed bag. For low numbers of clients, throughput on
  sequential reads has improved with the exception of 3.2.9 which
  was a disaster. For larger number of clients, it is a mix of
  gains and losses. This could be due to weakness in the methodology
  due to both a small filesize and a small number of iterations.

  Random read has improved.

  With the exception of 3.2.9, sequential writes have generally
  improved.

  Random write has a number of regressions and 3.2.9 is a diaster.

  Kernels 3.1 and 3.2 had unexpected swapping.

==========================================================
Machine:	sandy
Result:		http://www.csn.ul.ie/~mel/postings/mmtests-20120424/global-dhp__io-threaded-ext3/sandy/comparison.html
Arch:		x86-64
CPUs:		1 socket, 8 threads
Model:		Intel Core i7-2600
Disk:		Single Rotary Disk
==========================================================

tiobench
--------

  Like hydra, sequential reads were generally better for low numbers of
  clients. 3.4 is notable in that it regressed. Unlike hydra, 3.1 was
  the first bad kernel for sequential reads unlikely hydra where it was
  3.2. There are differences in the memory sizes and therefore the filesize
  and it implies that there is not a single cause of the regression.

  Random read has improved.

  Sequential writes have generally improved although it is interesting
  to note that 3.1 was a kernel that regressed. 3.4 is better than 2.6.32
  but it is interesting to note that it has regressed in comparison to 3.3.

  Random write has generally improved but again 3.4 is worse than 3.3.

  Like the other machines, 3.1 and 3.2 saw unexpected swapping.

-- 
Mel Gorman
SUSE Labs
