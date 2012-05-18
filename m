Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967708Ab2ERVTM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 17:19:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19964 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933132Ab2ERVTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 17:19:10 -0400
X-Authority-Analysis: v=2.0 cv=ae7jbGUt c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=uChq6B4iKcYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=6h1IcWuprMDIdrxlFqcA:9 a=RGh4pXfeqi6pz_Ys_OgA:7 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337375946.7562.11.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] power, trace: add tracing for device_resume
From: Steven Rostedt <rostedt@goodmis.org>
To: Sameer Nanda <snanda@chromium.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, rob@landley.net, len.brown@intel.com,
        pavel@ucw.cz, rjw@sisk.pl, fweisbec@gmail.com, mingo@redhat.com,
        jkosina@suse.cz, standby24x7@gmail.com, jj@chaosbits.net,
        paulmck@linux.vnet.ibm.com, josh@joshtriplett.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Date: Fri, 18 May 2012 17:19:06 -0400
In-Reply-To: <CANMivWbXVVd=wVqzC=FTDp7Pe3YtzR+0UcRPCPAmPN9uUV83RA@mail.gmail.com>
References: <1337365643-29261-1-git-send-email-snanda@chromium.org>
	 <20120518183756.GA3216@kroah.com>
	 <CANMivWb3iOnoVtZ8G8kh9-vXPUfNFpSP=QWue0QztbkeZ+uE=Q@mail.gmail.com>
	 <1337368492.7562.8.camel@gandalf.stny.rr.com>
	 <CANMivWbXVVd=wVqzC=FTDp7Pe3YtzR+0UcRPCPAmPN9uUV83RA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-18 at 13:58 -0700, Sameer Nanda wrote:
> On Fri, May 18, 2012 at 12:14 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > On Fri, 2012-05-18 at 11:57 -0700, Sameer Nanda wrote:
> >
> >> AFAICT, they are used for something completely different -- help solve
> >> suspend/resume issues by saving a hash in the RTC of the last device
> >> that suspended/resumed.  They don't use the perf tracing mechanism at
> >> all.
> >>
> >
> > Also note that all tracepoints have timestamps attached to them. You do
> > not need to add deltas. Do that in the userspace tools that read the
> > timestamps and events. This way you can have one DECLARE_EVENT_CLASS and
> > three DEFINE_EVENTs. This will save space.
> 
> Agreed on the space savings.  However, with the time_delta in the
> trace message itself, a one line shell script [1] that sorts on the
> time_delta field is sufficient to quickly spot the devices that take a
> long time to resume.  Without the time_delta field, the user tool is
> more complex since it needs to first match up the device_resume_in,
> device_resume_waited and device_resume_out traces and then calculate
> time deltas.
> 
> Seems like a worthwhile trade-off to me but I can take out the
> time_delta if the general consensus is otherwise.

Just note that every TRACE_EVENT() adds around 5k or more code. Every
DEFINE_EVENT adds just about 300 bytes.

> [1]: here's an example script I use for sorting the device resume times:
> cat /sys/kernel/debug/tracing/trace | grep device_resume_out | awk
> 'BEGIN { FS = "time_delta=" } ; { print $2 $0 }' | sort -n
> 

Question is, how often is this done? And that 5k is permanent for all
users.

-- Steve


