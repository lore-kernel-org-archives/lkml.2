Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210Ab2AIVhb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 16:37:31 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:36220 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932140Ab2AIVh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 16:37:26 -0500
Date: Mon, 09 Jan 2012 13:35:12 -0800 (PST)
Message-Id: <20120109.133512.1450319978863849902.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: akpm@linux-foundation.org, rostedt@goodmis.org, fweisbec@gmail.com,
        mingo@redhat.com, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: linux-next: build failure after merge of the final tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120109165950.53933c3050416bd242acff76@canb.auug.org.au>
References: <20120105190405.1e3191fb5a43b2a0f1655e1f@canb.auug.org.au>
	<20120105160448.dc482ef6.akpm@linux-foundation.org>
	<20120109165950.53933c3050416bd242acff76@canb.auug.org.au>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 09 Jan 2012 13:35:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 9 Jan 2012 16:59:50 +1100

>> > include/trace/events/kmem.h:267:1: error: implicit declaration of function 'check_trace_callback_type_mm_page_alloc_extfrag' [-Werror=implicit-function-declaration]
>> > In file included from include/trace/ftrace.h:774:0,
>> >                  from include/trace/define_trace.h:86,
>> >                  from include/trace/events/power.h:240,
>> >                  from kernel/trace/power-traces.c:14:
>> > include/trace/events/kmem.h: In function 'perf_test_probe_mm_page_pcpu_drain':
>> > include/trace/events/kmem.h:256:1: error: implicit declaration of function 'check_trace_callback_type_mm_page_pcpu_drain' [-Werror=implicit-function-declaration]

I think the problem has to do with slab_def.h's explicit inclusion of
trace/kmem.h

If this somehow gets included while we are expanding define_trace.h, then
TRACE_SYSTEM will get redefined and screw up all of the includes that
define_trace.h is trying to perform for the sake of power.h

Other architectures probably hit slab_def.h via some earlier includes
and therefore don't hit this situation like Sparc does.

Adding an explicit <linux/slab.h> include to power-traces.c indeed fixes
the build.
