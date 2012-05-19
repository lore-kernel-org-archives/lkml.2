Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677Ab2ESQce (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 12:32:34 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61135 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873Ab2ESQcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 12:32:31 -0400
Date: Sat, 19 May 2012 09:32:26 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Sameer Nanda <snanda@chromium.org>, Steven Rostedt <rostedt@goodmis.org>,
        rob@landley.net, len.brown@intel.com, pavel@ucw.cz, fweisbec@gmail.com,
        mingo@redhat.com, jkosina@suse.cz, standby24x7@gmail.com,
        jj@chaosbits.net, paulmck@linux.vnet.ibm.com, josh@joshtriplett.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH] power, trace: add tracing for device_resume
Message-ID: <20120519163226.GA24612@kroah.com>
References: <1337365643-29261-1-git-send-email-snanda@chromium.org>
 <20120518230117.GA6016@kroah.com>
 <CANMivWY=-ML2v0SOZp6uiNWQKqKZ=eY82otMLqQu8S4+OvKHMA@mail.gmail.com>
 <201205191359.20457.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201205191359.20457.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 19, 2012 at 01:59:20PM +0200, Rafael J. Wysocki wrote:
> On Saturday, May 19, 2012, Sameer Nanda wrote:
> > On Fri, May 18, 2012 at 4:01 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > > On Fri, May 18, 2012 at 03:17:32PM -0700, Sameer Nanda wrote:
> > >> On Fri, May 18, 2012 at 2:46 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > >> > On Friday, May 18, 2012, Sameer Nanda wrote:
> > >> >> On Fri, May 18, 2012 at 2:19 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > >> >> > On Fri, 2012-05-18 at 13:58 -0700, Sameer Nanda wrote:
> > >> >> >> On Fri, May 18, 2012 at 12:14 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > >> >> >> > On Fri, 2012-05-18 at 11:57 -0700, Sameer Nanda wrote:
> > >> >> >> >
> > >> >> >> >> AFAICT, they are used for something completely different -- help solve
> > >> >> >> >> suspend/resume issues by saving a hash in the RTC of the last device
> > >> >> >> >> that suspended/resumed.  They don't use the perf tracing mechanism at
> > >> >> >> >> all.
> > >> >> >> >>
> > >> >> >> >
> > >> >> >> > Also note that all tracepoints have timestamps attached to them. You do
> > >> >> >> > not need to add deltas. Do that in the userspace tools that read the
> > >> >> >> > timestamps and events. This way you can have one DECLARE_EVENT_CLASS and
> > >> >> >> > three DEFINE_EVENTs. This will save space.
> > >> >> >>
> > >> >> >> Agreed on the space savings.  However, with the time_delta in the
> > >> >> >> trace message itself, a one line shell script [1] that sorts on the
> > >> >> >> time_delta field is sufficient to quickly spot the devices that take a
> > >> >> >> long time to resume.  Without the time_delta field, the user tool is
> > >> >> >> more complex since it needs to first match up the device_resume_in,
> > >> >> >> device_resume_waited and device_resume_out traces and then calculate
> > >> >> >> time deltas.
> > >> >> >>
> > >> >> >> Seems like a worthwhile trade-off to me but I can take out the
> > >> >> >> time_delta if the general consensus is otherwise.
> > >> >> >
> > >> >> > Just note that every TRACE_EVENT() adds around 5k or more code. Every
> > >> >> > DEFINE_EVENT adds just about 300 bytes.
> > >> >>
> > >> >> Ok, let me respin the patch.  I am thinking of adding time_delta to
> > >> >> all three traces.  That way we should get the space saving while still
> > >> >> allowing quick spotting of devices that take long time to resume.
> > >> >
> > >> > Well, what's wrong with the code in drivers/base/power/main.c that
> > >> > is activated by adding initcall_debug to the kernel command line?
> > >>
> > >> Mostly that I hadn't looked closely at initcall_debug before writing my patch :)
> > >>
> > >> Now that I have taken a look at it, the main issue is that the kernel
> > >> command line needs to be modified to activate it.  We cannot do this
> > >> for our automated regression suites since the kernel command line is
> > >> protected on Chrome OS systems.
> > >
> > > You are kidding, right?  You have control over your test systems, don't
> > > bloat everyone's kernel by 5k just because your infrastructure is
> > > somehow something that you feel you can't change.
> > 
> > Fair enough.  But having to modify the kernel command line to do this
> > is clunky.  How about exposing the ability to turn on these
> > initcall_debug prints through a knob under /sys/power?
> 
> This might work, but first you'd need to make them depend on something
> different from initcall_debug (and make that thing in turn be set if
> initcall_debug is put into the kernel command line).  Then, you could
> export the new variable.
> 
> Greg, does that make sense to you?

Maybe, I'd like to see a patch first before agreeing with it though :)

