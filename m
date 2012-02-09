Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757909Ab2BIDa2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 22:30:28 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:37538 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757671Ab2BIDa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 22:30:26 -0500
X-Authority-Analysis: v=2.0 cv=T9kOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=NKm62CkMpMoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=JDjsHSkAAAAA:8 a=68eEZQRoAAAA:8 a=meVymXHHAAAA:8 a=_KvmP6zrONTWFvhUm4wA:9 a=PUjeQqilurYA:10 a=Hf6muOzgCGQA:10 a=7YLhZ6jOsBkA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1328758224.2200.134.camel@gandalf.stny.rr.com>
Subject: Re: linux-next: Tree for Feb 2 (trace/events/sunrpc.h)
From: Steven Rostedt <rostedt@goodmis.org>
To: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Wed, 08 Feb 2012 22:30:24 -0500
In-Reply-To: <1328757287.3234.76.camel@lade.trondhjem.org>
References: <20120202144516.11b33e667a7cbb8d85d96226@canb.auug.org.au>
	 <4F2AD18D.9030904@xenotime.net>
	 <1328755030.2200.133.camel@gandalf.stny.rr.com>
	 <1328757287.3234.76.camel@lade.trondhjem.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-09 at 03:14 +0000, Myklebust, Trond wrote:

> Hmm.... How about if we rather take that out of the RPC_DEBUG condition?
> I'm assuming that if someone compiles in the tracepoint code, then they
> want to be able to do a full trace independently of whether or not they
> set CONFIG_SYSCTL.

Works for me.

> 
> 8<---------------------------------------------------------------------
> From d051b60dcc3032b71cf8d9b96ac4bf24f12b6dcb Mon Sep 17 00:00:00 2001
> From: Trond Myklebust <Trond.Myklebust@netapp.com>
> Date: Wed, 8 Feb 2012 22:01:15 -0500
> Subject: [PATCH] SUNRPC: Ensure that we can trace waitqueues when
>  !defined(CONFIG_SYSCTL)
> 
> The tracepoint code relies on the queue->name being defined in order to
> be able to display the name of the waitqueue on which an RPC task is
> sleeping.
> 
> Reported-by: Randy Dunlap <rdunlap@xenotime.net>
> Reported-by: Steven Rostedt <rostedt@goodmis.org>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
> ---
>  include/linux/sunrpc/debug.h |    3 +++
>  include/linux/sunrpc/sched.h |   15 +++++++++++++--
>  net/sunrpc/sched.c           |    4 +---
>  3 files changed, 17 insertions(+), 5 deletions(-)
> 


