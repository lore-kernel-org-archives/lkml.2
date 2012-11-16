Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105Ab2KPPF6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 10:05:58 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2621 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab2KPPF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 10:05:57 -0500
X-Authority-Analysis: v=2.0 cv=RoZH3VaK c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=F2zS_u90JFsA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=wnFoji85akYA:10 a=VwQbUJbxAAAA:8 a=sNJI1D7C4c9jmhyp-pMA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1353078354.7586.14.camel@gandalf.local.home>
Subject: Re: Re: [RFC PATCH 0/2] kvm/vmx: Output TSC offset
From: Steven Rostedt <rostedt@goodmis.org>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: David Sharp <dhsharp@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Joerg Roedel <joerg.roedel@amd.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, Avi Kivity <avi@redhat.com>,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 16 Nov 2012 10:05:54 -0500
In-Reply-To: <50A355A2.5040101@hitachi.com>
References: <20121114013611.5338.15086.stgit@yunodevel>
	  <1352858437.18025.47.camel@gandalf.local.home>
	  <CAJL_ekvb89saY9F0F3ip-8xipuuRyJ1_M8hOyThu_0Q2=5sXgA@mail.gmail.com>
	 <1352860305.18025.48.camel@gandalf.local.home>
	 <50A355A2.5040101@hitachi.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-11-14 at 17:26 +0900, Yoshihiro YUNOMAE wrote:
> Thank you for commenting on my patch set.
> 
> (2012/11/14 11:31), Steven Rostedt wrote:
> > On Tue, 2012-11-13 at 18:03 -0800, David Sharp wrote:
> >> On Tue, Nov 13, 2012 at 6:00 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> >>> On Wed, 2012-11-14 at 10:36 +0900, Yoshihiro YUNOMAE wrote:
> >>>
> >>>> To merge the data like previous pattern, we apply this patch set. Then, we can
> >>>> get TSC offset of the guest as follows:
> >>>>
> >>>> $ dmesg | grep kvm
> >>>> [   57.717180] kvm: (2687) write TSC offset 18446743360465545001, now clock ##
> >>>>                       ^^^^                   ^^^^^^^^^^^^^^^^^^^^            |
> >>>>                       PID                         TSC offset                 |
> >>>>                                                             HOST TSC value --+
> >>>>
> >>>
> >>> Using printk to export something like this is IMO a nasty hack.
> >>>
> >>> Can't we create a /sys or /proc file to export the same thing?
> >>
> >> Since the value changes over the course of the trace, and seems to be
> >> part of the context of the trace, I think I'd include it as a
> >> tracepoint.
> >>
> >
> > I'm fine with that too.
> 
> Using some tracepoint is a nice idea, but there is one problem. Here,
> our discussion point is "the event which TSC offset is changed does not
> frequently occur, but the buffer must keep the event data."

If you can hold off a bit, for the 3.9 window, I plan on pushing
multiple buffers for ftrace. That is, you can create a separate buffer
just for the TSC offset events:

cd /sys/kernel/debug
echo tsc > instances/new
echo 1 > instances/tsc/events/tsc/offset/enable

Then the buffer will be used only for that event.

The code is pretty much ready, but I want to test it more before the 3.8
window opens, which is why I'm waiting for 3.9.

You can see the latest version here:

git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
branch: rfc/multi-buffers-v7

-- Steve


