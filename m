Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967483Ab2ERU6f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 16:58:35 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:43435 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933163Ab2ERU6a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 16:58:30 -0400
MIME-Version: 1.0
In-Reply-To: <1337368492.7562.8.camel@gandalf.stny.rr.com>
References: <1337365643-29261-1-git-send-email-snanda@chromium.org>
 <20120518183756.GA3216@kroah.com> <CANMivWb3iOnoVtZ8G8kh9-vXPUfNFpSP=QWue0QztbkeZ+uE=Q@mail.gmail.com>
 <1337368492.7562.8.camel@gandalf.stny.rr.com>
From: Sameer Nanda <snanda@chromium.org>
Date: Fri, 18 May 2012 13:58:09 -0700
X-Google-Sender-Auth: 8nc4J3l5hOgUN1pRUxWxz76wgLk
Message-ID: <CANMivWbXVVd=wVqzC=FTDp7Pe3YtzR+0UcRPCPAmPN9uUV83RA@mail.gmail.com>
Subject: Re: [PATCH] power, trace: add tracing for device_resume
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, rob@landley.net, len.brown@intel.com,
        pavel@ucw.cz, rjw@sisk.pl, fweisbec@gmail.com, mingo@redhat.com,
        jkosina@suse.cz, standby24x7@gmail.com, jj@chaosbits.net,
        paulmck@linux.vnet.ibm.com, josh@joshtriplett.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 12:14 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Fri, 2012-05-18 at 11:57 -0700, Sameer Nanda wrote:
>
>> AFAICT, they are used for something completely different -- help solve
>> suspend/resume issues by saving a hash in the RTC of the last device
>> that suspended/resumed.  They don't use the perf tracing mechanism at
>> all.
>>
>
> Also note that all tracepoints have timestamps attached to them. You do
> not need to add deltas. Do that in the userspace tools that read the
> timestamps and events. This way you can have one DECLARE_EVENT_CLASS and
> three DEFINE_EVENTs. This will save space.

Agreed on the space savings.  However, with the time_delta in the
trace message itself, a one line shell script [1] that sorts on the
time_delta field is sufficient to quickly spot the devices that take a
long time to resume.  Without the time_delta field, the user tool is
more complex since it needs to first match up the device_resume_in,
device_resume_waited and device_resume_out traces and then calculate
time deltas.

Seems like a worthwhile trade-off to me but I can take out the
time_delta if the general consensus is otherwise.

[1]: here's an example script I use for sorting the device resume times:
cat /sys/kernel/debug/tracing/trace | grep device_resume_out | awk
'BEGIN { FS = "time_delta=" } ; { print $2 $0 }' | sort -n


>
> -- Steve
>
>



-- 
Sameer
