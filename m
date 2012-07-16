Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab2GPUBH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 16:01:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51256 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721Ab2GPUBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 16:01:05 -0400
Date: Mon, 16 Jul 2012 22:00:13 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-numa@vger.kernel.org, Petr Holasek <pholasek@redhat.com>
Cc: Hillf Danton <dhillf@gmail.com>, Dan Smith <danms@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>, Alex Shi <alex.shi@intel.com>,
        Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Don Morris <don.morris@hp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: AutoNUMA benchmark 0.1
Message-ID: <20120716200013.GJ28148@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

With the collaboration of Petr Holasek we released a first 0.1 version
of the AutoNUMA benchmark.

It's now trivial to run it without the chance of mistakes, and you can
also see how fast the NUMA algorithms in the kernel converge the load
by checking the pdf charts it creates after each benchmark completes.

This benchmark can also setup hard/inverse bindings to benchmark the
hardware and measure the best/worst case (when run with hard bindings
no memory migration will ever happen and it starts computing in the
ideal memory layout, so it'll always be slightly faster than the
non-hard binding case).

To run it you just need numactl, gnuplot and gcc installed. After
cloning this git repo:

git clone git://gitorious.org/autonuma-benchmark/autonuma-benchmark.git

you can simply run it as root (or with sudo prefix):

./start_bench.sh -A

The above command will run all tests including the hard/inverse binds
(which require root privileges).

The first objective of this benchmark is to be able to track
regression in AutoNUMA, but it's also useful to to compare the results
of this benchmark on upstream, tip.git, and aa.git with AutoNUMA
enabled.

If you're only going to compare different NUMA placement algorithms in
different kernels, you can skip the inverse/hard bind tests to speed
up the benchmarking effort (the hard/invers bind tests should result
always the same). To skip the hard/inverse bind tests you can run it
like this:

./start_bench.sh -s -t

For a basic and quick benchmark, you can run it without parameters:

./start_bench.sh

If you encounter any problem or if you're interested to contribute
please CC Petr too.

Thanks,
Andrea
