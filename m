Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab2CWN1N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 09:27:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24635 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740Ab2CWN1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 09:27:11 -0400
Date: Fri, 23 Mar 2012 09:26:48 -0400
From: Don Zickus <dzickus@redhat.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Josh Boyer <jwboyer@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Avi Kivity <avi@redhat.com>, kvm <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: WARNING: at arch/x86/kernel/smp.c:119
 native_smp_send_reschedule+0x25/0x43()
Message-ID: <20120323132648.GA18218@redhat.com>
References: <CA+1xoqfYPYi2godgsgmnX7z7GQL+spNmMZhpdGU4UqfYGTB06g@mail.gmail.com>
 <4F34EC35.7010109@linux.vnet.ibm.com>
 <1328900283.25989.45.camel@laptop>
 <1328900633.25989.47.camel@laptop>
 <20120210200250.GG5650@redhat.com>
 <1328905121.25989.52.camel@laptop>
 <20120210203117.GI5650@redhat.com>
 <1328906163.25989.59.camel@laptop>
 <20120210210423.GJ5650@redhat.com>
 <CA+1xoqeSMSaXCUbZyB2GAXc+2i=gcX3+zP41ss45YUjyr7F_zA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+1xoqeSMSaXCUbZyB2GAXc+2i=gcX3+zP41ss45YUjyr7F_zA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2012 at 12:47:38PM +0200, Sasha Levin wrote:
> I'm just wondering about the status of the patches to fix this issue,
> this is still happening on linux-next.

I got distracted with other stuff.  I have been running code that does the
following in the shutdown path:

foreach_online_cpu
    cpu_down

but I get occasional hangs on reboot that I haven't gotten around to
debugging.  I assumed this is the approach Peter was suggesting though I
don't think he was sure if it was going to be reliable.

Cheers,
Don

> 
> On Fri, Feb 10, 2012 at 11:04 PM, Don Zickus <dzickus@redhat.com> wrote:
> > On Fri, Feb 10, 2012 at 09:36:03PM +0100, Peter Zijlstra wrote:
> >> On Fri, 2012-02-10 at 15:31 -0500, Don Zickus wrote:
> >> > So my second patch which I will eventually post will just skip the WARN_ON
> >> > if the system is going down.  Not sure if that is the proper way to address
> >> > this problem or change all of the stop_this_cpu code to use a different
> >> > bitmask than the cpu_online bitmask (but then you run the risk of a stuck
> >> > IPI I guess if the cpu is halted without notifying anyone).
> >>
> >> Yeah, the async hard kill of all cpus is bound to make problems.. what
> >> I'm wondering is, why is this in the normal shutdown path and not
> >> specific to a hard panic?
> >
> > I didn't write the original code, I just changed it from REBOOT_IRQ to
> > NMI and left all the stop_this_cpu stuff alone.
> >
> >>
> >> Trying to make this work is just not going to be pretty, and in the
> >> panic case we really don't care much.
> >
> > Sure.
> >
> > Cheers,
> > Don
