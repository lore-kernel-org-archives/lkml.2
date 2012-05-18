Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968067Ab2ERVlK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 17:41:10 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:53459 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968012Ab2ERVlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 17:41:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sameer Nanda <snanda@chromium.org>
Subject: Re: [PATCH] power, trace: add tracing for device_resume
Date: Fri, 18 May 2012 23:46:02 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc7+; KDE/4.6.0; x86_64; ; )
Cc: Steven Rostedt <rostedt@goodmis.org>, Greg KH <gregkh@linuxfoundation.org>,
        rob@landley.net, len.brown@intel.com, pavel@ucw.cz, fweisbec@gmail.com,
        mingo@redhat.com, jkosina@suse.cz, standby24x7@gmail.com,
        jj@chaosbits.net, paulmck@linux.vnet.ibm.com, josh@joshtriplett.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
References: <1337365643-29261-1-git-send-email-snanda@chromium.org> <1337375946.7562.11.camel@gandalf.stny.rr.com> <CANMivWZ4ygG5R7ob_Q-pkAFpoKAkK_iQf3w2eiw5Gv65AbTYNw@mail.gmail.com>
In-Reply-To: <CANMivWZ4ygG5R7ob_Q-pkAFpoKAkK_iQf3w2eiw5Gv65AbTYNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201205182346.02296.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 18, 2012, Sameer Nanda wrote:
> On Fri, May 18, 2012 at 2:19 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > On Fri, 2012-05-18 at 13:58 -0700, Sameer Nanda wrote:
> >> On Fri, May 18, 2012 at 12:14 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> >> > On Fri, 2012-05-18 at 11:57 -0700, Sameer Nanda wrote:
> >> >
> >> >> AFAICT, they are used for something completely different -- help solve
> >> >> suspend/resume issues by saving a hash in the RTC of the last device
> >> >> that suspended/resumed.  They don't use the perf tracing mechanism at
> >> >> all.
> >> >>
> >> >
> >> > Also note that all tracepoints have timestamps attached to them. You do
> >> > not need to add deltas. Do that in the userspace tools that read the
> >> > timestamps and events. This way you can have one DECLARE_EVENT_CLASS and
> >> > three DEFINE_EVENTs. This will save space.
> >>
> >> Agreed on the space savings.  However, with the time_delta in the
> >> trace message itself, a one line shell script [1] that sorts on the
> >> time_delta field is sufficient to quickly spot the devices that take a
> >> long time to resume.  Without the time_delta field, the user tool is
> >> more complex since it needs to first match up the device_resume_in,
> >> device_resume_waited and device_resume_out traces and then calculate
> >> time deltas.
> >>
> >> Seems like a worthwhile trade-off to me but I can take out the
> >> time_delta if the general consensus is otherwise.
> >
> > Just note that every TRACE_EVENT() adds around 5k or more code. Every
> > DEFINE_EVENT adds just about 300 bytes.
> 
> Ok, let me respin the patch.  I am thinking of adding time_delta to
> all three traces.  That way we should get the space saving while still
> allowing quick spotting of devices that take long time to resume.

Well, what's wrong with the code in drivers/base/power/main.c that
is activated by adding initcall_debug to the kernel command line?

Rafael
