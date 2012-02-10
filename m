Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760205Ab2BJVEr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 16:04:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50092 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758980Ab2BJVEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 16:04:45 -0500
Date: Fri, 10 Feb 2012 16:04:23 -0500
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Sasha Levin <levinsasha928@gmail.com>, Josh Boyer <jwboyer@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Avi Kivity <avi@redhat.com>,
        kvm <kvm@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, Suresh B Siddha <suresh.b.siddha@intel.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: WARNING: at arch/x86/kernel/smp.c:119
 native_smp_send_reschedule+0x25/0x43()
Message-ID: <20120210210423.GJ5650@redhat.com>
References: <1328751082.5611.6.camel@lappy>
 <CA+5PVA6HNqYv7kw3Oq_+05LwrXwtnNnZDkntcrncT2OmGXDd=w@mail.gmail.com>
 <CA+1xoqfYPYi2godgsgmnX7z7GQL+spNmMZhpdGU4UqfYGTB06g@mail.gmail.com>
 <4F34EC35.7010109@linux.vnet.ibm.com>
 <1328900283.25989.45.camel@laptop>
 <1328900633.25989.47.camel@laptop>
 <20120210200250.GG5650@redhat.com>
 <1328905121.25989.52.camel@laptop>
 <20120210203117.GI5650@redhat.com>
 <1328906163.25989.59.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328906163.25989.59.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 10, 2012 at 09:36:03PM +0100, Peter Zijlstra wrote:
> On Fri, 2012-02-10 at 15:31 -0500, Don Zickus wrote:
> > So my second patch which I will eventually post will just skip the WARN_ON
> > if the system is going down.  Not sure if that is the proper way to address
> > this problem or change all of the stop_this_cpu code to use a different
> > bitmask than the cpu_online bitmask (but then you run the risk of a stuck
> > IPI I guess if the cpu is halted without notifying anyone). 
> 
> Yeah, the async hard kill of all cpus is bound to make problems.. what
> I'm wondering is, why is this in the normal shutdown path and not
> specific to a hard panic?

I didn't write the original code, I just changed it from REBOOT_IRQ to
NMI and left all the stop_this_cpu stuff alone.

> 
> Trying to make this work is just not going to be pretty, and in the
> panic case we really don't care much.

Sure.

Cheers,
Don
