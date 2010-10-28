Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933042Ab0J1Mxr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 08:53:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:57264 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757397Ab0J1Mxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 08:53:46 -0400
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=-qfxTvYugxgA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=AyzZ_k07o-anCrnS4mAA:9 a=0rfbrulrvpCVjGtCcIuVxb38h5gA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] tracing: fix TRACE_EVENT power tracepoint creation
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20101028110321.GA24711@Krystal>
References: <20101028021632.GA18117@Krystal>
	 <1288232716.18238.140.camel@gandalf.stny.rr.com>
	 <20101028110321.GA24711@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 28 Oct 2010 08:53:44 -0400
Message-ID: <1288270424.18238.211.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-28 at 07:03 -0400, Mathieu Desnoyers wrote:

> Given that trace/power.h is inluded in more than one .c file, generating
> DEFINE_TRACE() when CREATE_TRACE_POINTS is not set does not work. So what
> alternative do you suggest ?

Right, DEFINE_TRACE should only be set when CREATE_TRACE_POINTS is set,
and that is only set in the C file that the DEFINE_TRACE is to be
defined.

In fact, I don't even see what bug you are trying to fix?

The file include/trace/define_trace.h converts all the TRACE_EVENTS()
into DEFINE_TRACE() when CREATE_TRACE_POINTS is set. No other C file
that includes power.h should have CREATE_TRACE_POINTS set. I guess if it
did, the CONFIG_EVENT_TRACING would break too.

It should just work.

-- Steve


