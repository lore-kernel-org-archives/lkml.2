Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822Ab1ARRBT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 12:01:19 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:37060 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab1ARRBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 12:01:18 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=I98iFNk1EVwA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=IU6EI_ANgppSYHbGRbkA:9 a=JluYTsPGgyFOaazmsDh-zoYhleIA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] tracing: remove superfluous sub instructions
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, mingo@elte.hu,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110118164148.GD1941@jolsa.brq.redhat.com>
References: <1295364498-9288-1-git-send-email-jolsa@redhat.com>
	 <20110118155159.GA1791@nowhere>
	 <1295367762.12215.2.camel@gandalf.stny.rr.com>
	 <20110118164148.GD1941@jolsa.brq.redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 18 Jan 2011 12:01:17 -0500
Message-ID: <1295370077.12215.13.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-18 at 17:41 +0100, Jiri Olsa wrote:

> ops, missed this one..
> 
> would it make sense to update the IP inside the function_trace_probe_call
> function to save one instruction in the entry code used by all? or it's
> not worth it..

That would require function_trace_probe_call() to handle arch
dependencies. I would like to keep arch dependent code in the arch
subsystem when possible.

This change only saves a subtraction to a register. It only gets called
if we are tracing functions. This modification is far into the noise
that is caused by the tracer. I don't think it is worth it as it will
cause head aches with knowing how to handle the ip from the users of the
function tracer.

I do plan on making the function tracer a bit more generic for common
users. I would like to keep the ip at the call site of mcount.

-- Steve


