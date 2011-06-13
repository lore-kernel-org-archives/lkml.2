Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430Ab1FMCHR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 22:07:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:30920 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751725Ab1FMCHN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 22:07:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,356,1304319600"; 
   d="scan'208";a="12705269"
From: "Cui, Dexuan" <dexuan.cui@intel.com>
To: "'Mathieu Desnoyers'" <mathieu.desnoyers@efficios.com>,
        "ltt-dev@lists.casi.polymtl.ca" <ltt-dev@lists.casi.polymtl.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rp@svcs.cs.pdx.edu" <rp@svcs.cs.pdx.edu>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Mon, 13 Jun 2011 10:06:09 +0800
Subject: RE: [ltt-dev] [RELEASE] Userspace RCU 0.6.0
Thread-Topic: [ltt-dev] [RELEASE] Userspace RCU 0.6.0
Thread-Index: Acwn1O0CgoDESZk8SEqyXsxjtlihAwBmSgoA
Message-ID: <1865303E0DED764181A9D882DEF65FB699650124A2@shsmsx502.ccr.corp.intel.com>
References: <20110611011417.GA8722@Krystal>
In-Reply-To: <20110611011417.GA8722@Krystal>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> liburcu is a LGPLv2.1 userspace RCU (read-copy-update) library. This
> data synchronization library provides read-side access which scales
> linearly with the number of cores. It does so by allowing multiples
> copies of a given data structure to live at the same time, and by
> monitoring the data structure accesses to detect grace periods after
> which memory reclamation is possible.
> 
> Changelog:
> 
> - Added call_rcu() support, graciously contributed by Paul E.
> McKenney. 
> - Added urcu/cds.h and merged all "Concurrent Data Containers" (CDS)
>   into a single .so: liburcu-cds.so to have a single header/shared
>   object holding all concurrency-aware data containers. It provides
>   support for RCU lists, queues and stacks at the moment.
> - liburcu 0.6.0 now allows linking a single application with multiple
>   flavors of RCU. This required a library API change which is
>   incompatible with older 0.5.x liburcu. The .so version number
>   is therefore bumped from 0 to 1 (e.g. liburcu.so.1).
> - Added "atfork" handling API, documented in README. Only useful for
>   processes using fork() without following exec().
> - Renaming the following files, keeping the old files (producing a
>   compiler warning):
>     urcu/uatomic_arch.h -> urcu/uatomic.h
>     urcu/urcu-futex.h -> urcu/futex.h
>     urcu/urcu_ref.h -> urcu/ref.h
> 
> Project website: http://lttng.org/urcu
> Download link: http://www.lttng.org/files/urcu/

Hi Mathieu,
The release can't build in my side:

$ tar -jxf userspace-rcu-0.6.0.tar.bz2 && cd userspace-rcu-0.6.0 && ./configure && make

make  all-recursive
make[1]: Entering directory `/home/dcui/userspace-rcu-0.6.0'
Making all in .
make[2]: Entering directory `/home/dcui/userspace-rcu-0.6.0'
  CC     wfqueue.lo
  CC     wfstack.lo
  CC     rculfqueue.lo
  CC     rculfstack.lo
  CCLD   liburcu-cds.la
  CC     urcu.lo
urcu.c:438:32: error: urcu-call-rcu-impl.h: No such file or directory
urcu.c:439:29: error: urcu-defer-impl.h: No such file or directory
make[2]: *** [urcu.lo] Error 1
make[2]: Leaving directory `/home/dcui/userspace-rcu-0.6.0'
make[1]: *** [all-recursive] Error 1
make[1]: Leaving directory `/home/dcui/userspace-rcu-0.6.0'
make: *** [all] Error 2

Can you please have a look?

Thanks,
-- Dexuan