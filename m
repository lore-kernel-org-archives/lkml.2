Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329Ab2KPTR5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 14:17:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17545 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753250Ab2KPTRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 14:17:55 -0500
Date: Fri, 16 Nov 2012 16:56:27 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        David Sharp <dhsharp@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Joerg Roedel <joerg.roedel@amd.com>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, Avi Kivity <avi@redhat.com>,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Re: [RFC PATCH 0/2] kvm/vmx: Output TSC offset
Message-ID: <20121116185627.GA28622@amt.cnet>
References: <20121114013611.5338.15086.stgit@yunodevel>
 <1352858437.18025.47.camel@gandalf.local.home>
 <CAJL_ekvb89saY9F0F3ip-8xipuuRyJ1_M8hOyThu_0Q2=5sXgA@mail.gmail.com>
 <1352860305.18025.48.camel@gandalf.local.home>
 <50A355A2.5040101@hitachi.com>
 <1353078354.7586.14.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353078354.7586.14.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 10:05:54AM -0500, Steven Rostedt wrote:
> On Wed, 2012-11-14 at 17:26 +0900, Yoshihiro YUNOMAE wrote:
> > Thank you for commenting on my patch set.
> > 
> > (2012/11/14 11:31), Steven Rostedt wrote:
> > > On Tue, 2012-11-13 at 18:03 -0800, David Sharp wrote:
> > >> On Tue, Nov 13, 2012 at 6:00 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > >>> On Wed, 2012-11-14 at 10:36 +0900, Yoshihiro YUNOMAE wrote:
> > >>>
> > >>>> To merge the data like previous pattern, we apply this patch set. Then, we can
> > >>>> get TSC offset of the guest as follows:
> > >>>>
> > >>>> $ dmesg | grep kvm
> > >>>> [   57.717180] kvm: (2687) write TSC offset 18446743360465545001, now clock ##
> > >>>>                       ^^^^                   ^^^^^^^^^^^^^^^^^^^^            |
> > >>>>                       PID                         TSC offset                 |
> > >>>>                                                             HOST TSC value --+
> > >>>>
> > >>>
> > >>> Using printk to export something like this is IMO a nasty hack.
> > >>>
> > >>> Can't we create a /sys or /proc file to export the same thing?
> > >>
> > >> Since the value changes over the course of the trace, and seems to be
> > >> part of the context of the trace, I think I'd include it as a
> > >> tracepoint.
> > >>
> > >
> > > I'm fine with that too.
> > 
> > Using some tracepoint is a nice idea, but there is one problem. Here,
> > our discussion point is "the event which TSC offset is changed does not
> > frequently occur, but the buffer must keep the event data."
> 
> If you can hold off a bit, for the 3.9 window, I plan on pushing
> multiple buffers for ftrace. That is, you can create a separate buffer
> just for the TSC offset events:
> 
> cd /sys/kernel/debug
> echo tsc > instances/new
> echo 1 > instances/tsc/events/tsc/offset/enable
> 
> Then the buffer will be used only for that event.
> 
> The code is pretty much ready, but I want to test it more before the 3.8
> window opens, which is why I'm waiting for 3.9.
> 
> You can see the latest version here:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> branch: rfc/multi-buffers-v7
> 
> -- Steve

You need the tsc offset change event and the main events to be ordered,
so i can't see how this helps.

