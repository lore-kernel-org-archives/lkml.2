Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758966Ab0EYBzi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 21:55:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:50243 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758749Ab0EYBzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 21:55:37 -0400
X-Authority-Analysis: v=1.1 cv=muTmBHIsIIrvj5np50lvqqEF3x9MmSj/zDSU9q1ni6E= c=1 sm=0 a=HguAhMkt-QwA:10 a=uEzv4HemXiYA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=m5CNwJbRKoju0NDaGqUA:9 a=ww42xmaBX2srE1TL5BkOII1jF80A:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: FUNCTION_TRACER: can it be used to trace early bootup functions
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Iram Shahzad <iram.shahzad@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <06EE497F774E482693005209CB740D6A@rainbow>
References: <06EE497F774E482693005209CB740D6A@rainbow>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 24 May 2010 21:55:34 -0400
Message-ID: <1274752534.22648.186.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-24 at 15:55 +0900, Iram Shahzad wrote:
> Hi
> 
> I would like to know whether the Kernel Function Tracer
> (kernel/trace/trace_functions) be used to trace early kernel
> bootup functions starting from start_kernel?
> My arch is ARM, by the way.
> 
> I have done some trials but it doesn't seem to trace early
> bootup functions. I even made it the default tracer replacing
> the nop tracer, but still it doesn't give me trace from
> start_kernel.
> 
> Looking at the source code, it seems to me that it starts
> recording data only after its own initialization. So does it
> mean that by design it does not support early tracing?

The main reason it does not support early tracing is that we need memory
management initialized before we can setup tracing. The tracing needs to
go somewhere :-)

With my previous tracer (logdev) I had a way to initialize the ring
buffer via bootmem. This allowed for tracing as soon as bootmem could be
allocated.

It is still feasible to add a way to do function tracing with bootmem, I
just never got around to it.

> 
> Please CC me in the reply.

Don't worry, that's the default way for LKML ;-)

-- Steve


