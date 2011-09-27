Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742Ab1I0Udx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 16:33:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59893 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753727Ab1I0Udv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 16:33:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v1 1/2] PM/runtime: introduce trace points for tracing rpm_* functions
Date: Tue, 27 Sep 2011 22:36:03 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: tom.leiming@gmail.com, stern@rowland.harvard.edu,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, fweisbec@gmail.com,
        Ming Lei <ming.lei@canonical.com>
References: <1317118338-4040-1-git-send-email-tom.leiming@gmail.com> <201109272229.23250.rjw@sisk.pl> <1317155512.26514.36.camel@gandalf.stny.rr.com>
In-Reply-To: <1317155512.26514.36.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201109272236.03683.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 27, 2011, Steven Rostedt wrote:
> On Tue, 2011-09-27 at 22:29 +0200, Rafael J. Wysocki wrote:
> > On Tuesday, September 27, 2011, tom.leiming@gmail.com wrote:
> > > From: Ming Lei <ming.lei@canonical.com>
> > > 
> > > This patch introduces 3 trace points to prepare for tracing
> > > rpm_idle/rpm_suspend/rpm_resume functions, so we can use these
> > > trace points to replace the current dev_dbg().
> > > 
> > > Cc: Steven Rostedt rostedt@goodmis.org
> > > Signed-off-by: Ming Lei <ming.lei@canonical.com>
> > 
> > I get the following build warning from it:
> > 
> >   GEN     /home/rafael/src/build/mainline/tosh/Makefile
> >   CHK     include/linux/version.h
> >   Using /home/rafael/src/linux as source for kernel
> >   CHK     include/generated/utsrelease.h
> >   CALL    /home/rafael/src/linux/scripts/checksyscalls.sh
> >   CHK     include/generated/compile.h
> >   CC      drivers/base/power/runtime.o
> >   CC      kernel/trace/rpm-traces.o
> > In file included from /home/rafael/src/linux/include/trace/ftrace.h:296:0,
> >                  from /home/rafael/src/linux/include/trace/define_trace.h:96,
> >                  from /home/rafael/src/linux/include/trace/events/rpm.h:99,
> >                  from /home/rafael/src/linux/kernel/trace/rpm-traces.c:15:
> > /home/rafael/src/linux/include/trace/events/rpm.h: In function ‘ftrace_raw_output_rpm_return_int’:
> > /home/rafael/src/linux/include/trace/events/rpm.h:76:1: warning: format ‘%p’ expects type ‘void *’, but argument 3 has type ‘long unsigned int’
> > 
> > Care to check?
> > 
> > Rafael
> 
> > > +TRACE_EVENT(rpm_return_int,
> > > +	TP_PROTO(struct device *dev, unsigned long ip, int ret),
> > > +	TP_ARGS(dev, ip, ret),
> > > +
> > > +	TP_STRUCT__entry(
> > > +		__string(       name,		dev_name(dev))
> > > +		__field(	unsigned long,		ip	)
> > > +		__field(	int,			ret	)
> > > +	),
> > > +
> > > +	TP_fast_assign(
> > > +		__assign_str(name, dev_name(dev));
> > > +		__entry->ip = ip;
> > > +		__entry->ret = ret;
> > > +	),
> > > +
> > > +	TP_printk("%pS:%s ret=%d", __entry->ip, __get_str(name),
> > > +		__entry->ret)
> > > +);
> > > +
> 
> 
> 	TP_printk("%pS:%s ret=%d", (void *)__entry->ip, __get_str(name),
> 		__entry->ret)
> 
> try that.

Well, that certainly will work, but is it the right fix?

Rafael
