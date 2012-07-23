Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932Ab2GWVOt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 17:14:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54004 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754798Ab2GWVOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 17:14:48 -0400
Date: Mon, 23 Jul 2012 22:14:44 +0100
From: Mel Gorman <mgorman@suse.de>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Subject: [MMTests] Sysbench read-only on ext4
Message-ID: <20120723211444.GB9222@suse.de>
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

Configuration:	global-dhp__io-sysbench-large-ro-ext4
Result: 	http://www.csn.ul.ie/~mel/postings/mmtests-20120424/global-dhp__io-sysbench-large-ro-ext4
Benchmarks:	sysbench

Summary
=======

Looking better in places than ext3 but still of concern.

Benchmark notes
===============

mkfs was run on system startup. No attempt was made to age it. No
special mkfs or mount options were used.

sysbench is an OLTP-like benchmark. The test type was "complex" and
read-only. The table size was 50,000,000 rows regardless of memory size
but far exceeds the memory size of any of the test machines. sysbench
was chosen because it's a reasonably complex OLTP-like benchmark with
straight-forward prerequisites.

The backing database was postgres.

===========================================================
Machine:	arnold
Result:		http://www.csn.ul.ie/~mel/postings/mmtests-20120424/global-dhp__io-sysbench-large-ro-ext4/arnold/comparison.html
Arch:		x86
CPUs:		1 socket, 2 threads
Model:		Pentium 4
Disk:		Single Rotary Disk
===========================================================

sysbench
--------
  Generally regresssed.

  Swapping for kernels 3.1 and 3.2 is very high.

==========================================================
Machine:	hydra
Result:		http://www.csn.ul.ie/~mel/postings/mmtests-20120424/global-dhp__io-sysbench-large-ro-ext4/hydra/comparison.html
Arch:		x86-64
CPUs:		1 socket, 4 threads
Model:		AMD Phenom II X4 940
Disk:		Single Rotary Disk
Status:		Ok
==========================================================

sysbench
--------
  For low number of clients, this has generally improved.

  Swapping in kernel 3.1 was high.

==========================================================
Machine:	sandy
Result:		http://www.csn.ul.ie/~mel/postings/mmtests-20120424/global-dhp__io-sysbench-large-ro-ext4/sandy/comparison.html
Arch:		x86-64
CPUs:		1 socket, 8 threads
Model:		Intel Core i7-2600
Disk:		Single Rotary Disk
Status:		
==========================================================

  Generally this is telling a much better story but this could be because
  of the much larger memory size of this machine offsetting some other
  regression.

  Swapping in 3.1 and 3.2.

-- 
Mel Gorman
SUSE Labs
