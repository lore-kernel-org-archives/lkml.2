Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932565Ab2IFRbS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 13:31:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17778 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab2IFRbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 13:31:17 -0400
X-Authority-Analysis: v=2.0 cv=C49rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=noUg4i2VpmoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=LWn315AbkCwA:10 a=mDV3o1hIAAAA:8 a=c0JE3XxB9MPW__p2XdAA:9 a=PUjeQqilurYA:10 a=2fcrIxHVTVsA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1346952676.1680.44.camel@gandalf.local.home>
Subject: Re: does gcc gives a false warning in
 kernel/trace/trace_events_filter.c ?
From: Steven Rostedt <rostedt@goodmis.org>
To: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Date: Thu, 06 Sep 2012 13:31:16 -0400
In-Reply-To: <5048D0E5.20103@gmx.de>
References: <50432132.90307@gmx.de>
	 <1346864883.27919.56.camel@gandalf.local.home> <5048D0E5.20103@gmx.de>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-06 at 18:35 +0200, Toralf Förster wrote:

> I filed a bug report
> 
> http://gcc.gnu.org/bugzilla/show_bug.cgi?id=54495
> and got this answer : 
> 
> --- Comment #1 from Hans-Peter Nilsson <hp at gcc dot gnu.org> 2012-09-05 22:14:00 UTC ---
> But if the call to ftrace_function_filter_re sets re_cnt to 0, then ret indeed
> will be used uninitialized AFAICT.  What am I missing?
> 

That I think we are looking at two different code bases ;-)

I've been looking at what's been queued for 3.7 and not what's in
mainline. If you look at tip/master, or even linux-next, you'll find:

commit 92d8d4a8b0f "tracing/filter: Add missing initialization"

Which does:

 static int __ftrace_function_set_filter(int filter, char *buf, int len,
                                        struct function_filter_data *data)
 {
-       int i, re_cnt, ret;
+       int i, re_cnt, ret = -EINVAL;
        int *reset;
        char **re;


Thus, you were correct. This could have been marked urgent, but as it
isn't that big of a deal I just queued it for the next merge window.

-- Steve


