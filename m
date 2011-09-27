Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab1I0Ubz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 16:31:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:40522 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979Ab1I0Ubx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 16:31:53 -0400
X-Authority-Analysis: v=1.1 cv=XWD5/VRj2HUJOhsR8cgmvPBlhMACpZXxseY1Kn/ehQI= c=1 sm=0 a=nYxVPzDsqTAA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=pGLkceISAAAA:8 a=DfNHnWVPAAAA:8 a=meVymXHHAAAA:8 a=yuIvlRvjANUQhrOiP44A:9 a=j5m9wX5KHMJQ6w3rmV4A:7 a=QEXdDO2ut3YA:10 a=MSl-tDqOz04A:10 a=lBRciGGoxdUA:10 a=jeBq3FmKZ4MA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [PATCH v1 1/2] PM/runtime: introduce trace points for tracing
 rpm_* functions
From: Steven Rostedt <rostedt@goodmis.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: tom.leiming@gmail.com, stern@rowland.harvard.edu,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, fweisbec@gmail.com,
        Ming Lei <ming.lei@canonical.com>
Date: Tue, 27 Sep 2011 16:31:50 -0400
In-Reply-To: <201109272229.23250.rjw@sisk.pl>
References: <1317118338-4040-1-git-send-email-tom.leiming@gmail.com>
	 <1317118338-4040-2-git-send-email-tom.leiming@gmail.com>
	 <201109272229.23250.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 8bit
Message-ID: <1317155512.26514.36.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-27 at 22:29 +0200, Rafael J. Wysocki wrote:
> On Tuesday, September 27, 2011, tom.leiming@gmail.com wrote:
> > From: Ming Lei <ming.lei@canonical.com>
> > 
> > This patch introduces 3 trace points to prepare for tracing
> > rpm_idle/rpm_suspend/rpm_resume functions, so we can use these
> > trace points to replace the current dev_dbg().
> > 
> > Cc: Steven Rostedt rostedt@goodmis.org
> > Signed-off-by: Ming Lei <ming.lei@canonical.com>
> 
> I get the following build warning from it:
> 
>   GEN     /home/rafael/src/build/mainline/tosh/Makefile
>   CHK     include/linux/version.h
>   Using /home/rafael/src/linux as source for kernel
>   CHK     include/generated/utsrelease.h
>   CALL    /home/rafael/src/linux/scripts/checksyscalls.sh
>   CHK     include/generated/compile.h
>   CC      drivers/base/power/runtime.o
>   CC      kernel/trace/rpm-traces.o
> In file included from /home/rafael/src/linux/include/trace/ftrace.h:296:0,
>                  from /home/rafael/src/linux/include/trace/define_trace.h:96,
>                  from /home/rafael/src/linux/include/trace/events/rpm.h:99,
>                  from /home/rafael/src/linux/kernel/trace/rpm-traces.c:15:
> /home/rafael/src/linux/include/trace/events/rpm.h: In function ‘ftrace_raw_output_rpm_return_int’:
> /home/rafael/src/linux/include/trace/events/rpm.h:76:1: warning: format ‘%p’ expects type ‘void *’, but argument 3 has type ‘long unsigned int’
> 
> Care to check?
> 
> Rafael

> > +TRACE_EVENT(rpm_return_int,
> > +	TP_PROTO(struct device *dev, unsigned long ip, int ret),
> > +	TP_ARGS(dev, ip, ret),
> > +
> > +	TP_STRUCT__entry(
> > +		__string(       name,		dev_name(dev))
> > +		__field(	unsigned long,		ip	)
> > +		__field(	int,			ret	)
> > +	),
> > +
> > +	TP_fast_assign(
> > +		__assign_str(name, dev_name(dev));
> > +		__entry->ip = ip;
> > +		__entry->ret = ret;
> > +	),
> > +
> > +	TP_printk("%pS:%s ret=%d", __entry->ip, __get_str(name),
> > +		__entry->ret)
> > +);
> > +


	TP_printk("%pS:%s ret=%d", (void *)__entry->ip, __get_str(name),
		__entry->ret)

try that.

-- Steve


