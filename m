Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203Ab2AIVlx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 16:41:53 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:38708 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932071Ab2AIVlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 16:41:51 -0500
X-Authority-Analysis: v=2.0 cv=Pb19d1dd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=5mlinyXLCh8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=rOUgymgbAAAA:8 a=DEoM-CAtu6HczL6noSAA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1326145304.7642.40.camel@gandalf.stny.rr.com>
Subject: Re: linux-next: build failure after merge of the final tree
From: Steven Rostedt <rostedt@goodmis.org>
To: David Miller <davem@davemloft.net>
Cc: sfr@canb.auug.org.au, akpm@linux-foundation.org, fweisbec@gmail.com,
        mingo@redhat.com, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Date: Mon, 09 Jan 2012 16:41:44 -0500
In-Reply-To: <20120109.133512.1450319978863849902.davem@davemloft.net>
References: <20120105190405.1e3191fb5a43b2a0f1655e1f@canb.auug.org.au>
	 <20120105160448.dc482ef6.akpm@linux-foundation.org>
	 <20120109165950.53933c3050416bd242acff76@canb.auug.org.au>
	 <20120109.133512.1450319978863849902.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-09 at 13:35 -0800, David Miller wrote:
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 9 Jan 2012 16:59:50 +1100
> 
> >> > include/trace/events/kmem.h:267:1: error: implicit declaration of function 'check_trace_callback_type_mm_page_alloc_extfrag' [-Werror=implicit-function-declaration]
> >> > In file included from include/trace/ftrace.h:774:0,
> >> >                  from include/trace/define_trace.h:86,
> >> >                  from include/trace/events/power.h:240,
> >> >                  from kernel/trace/power-traces.c:14:
> >> > include/trace/events/kmem.h: In function 'perf_test_probe_mm_page_pcpu_drain':
> >> > include/trace/events/kmem.h:256:1: error: implicit declaration of function 'check_trace_callback_type_mm_page_pcpu_drain' [-Werror=implicit-function-declaration]
> 
> I think the problem has to do with slab_def.h's explicit inclusion of
> trace/kmem.h
> 
> If this somehow gets included while we are expanding define_trace.h, then
> TRACE_SYSTEM will get redefined and screw up all of the includes that
> define_trace.h is trying to perform for the sake of power.h
> 
> Other architectures probably hit slab_def.h via some earlier includes
> and therefore don't hit this situation like Sparc does.
> 
> Adding an explicit <linux/slab.h> include to power-traces.c indeed fixes
> the build.

Yeah, I have a patch that fixes the bug (removing the
trace/events/kmem.h from slab.h). I'll be posting it as soon as it
finishes my final tests.

-- Steve


