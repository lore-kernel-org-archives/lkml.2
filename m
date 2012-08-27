Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab2H0IXw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 04:23:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:16947 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753153Ab2H0IXv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 04:23:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,318,1344236400"; 
   d="scan'208";a="214346885"
Date: Mon, 27 Aug 2012 16:18:15 +0800
From: Feng Tang <feng.tang@intel.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: <acme@redhat.com>, <mingo@elte.hu>, <a.p.zijlstra@chello.nl>,
        <dsahern@gmail.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] perf tools: Fix a misuse of for_each_set_bit() in
 session.c
Message-ID: <20120827161815.4a1a84c7@feng-i7>
In-Reply-To: <871uisepf8.fsf@sejong.aot.lge.com>
References: <1346053107-11946-1-git-send-email-feng.tang@intel.com>
	<1346053107-11946-4-git-send-email-feng.tang@intel.com>
	<871uisepf8.fsf@sejong.aot.lge.com>
Organization: intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 27 Aug 2012 16:59:07 +0900
Namhyung Kim <namhyung@kernel.org> wrote:

> Hi,
> 
> On Mon, 27 Aug 2012 15:38:27 +0800, Feng Tang wrote:
> > In regs_dump__printf() it use for_each_set_bit() for bit ops by
> > casting a (u64 *) to a (unsigned long *), this works for 64 bits
> > machine, but will fail on 32 bits ones.
> >
> > Fix it by using the raw bit comparing method.
> 
> Did it really cause a build failure or a program error?  If not, it
> looks better to keep using for_each_set_bit() interface.  How about
> casting the @mask to (void *) ?

It's a compile error:

cc1: warnings being treated as errors
util/session.c: In function ‘perf_session_deliver_event’:
util/include/linux/bitops.h:104: error: dereferencing pointer ‘p’ does break strict-aliasing rules
util/include/linux/bitops.h:96: error: dereferencing pointer ‘p’ does break strict-aliasing rules
util/session.c:907: note: initialized from here
util/include/linux/bitops.h:96: note: initialized from here
make: *** [util/session.o] Error 1
make: *** Waiting for unfinished jobs....

Casting the @mask to (void *) still sees the same error

Thanks,
Feng
