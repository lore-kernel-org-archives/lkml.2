Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933522Ab1JDTrO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 15:47:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47766 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933441Ab1JDTrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 15:47:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Borislav Petkov <bp@amd64.org>
Subject: Re: [BUGFIX][PATCH] Freezer, CPU hotplug, x86 Microcode: Fix task freezing failures
Date: Tue, 4 Oct 2011 21:49:30 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc8+; KDE/4.6.0; x86_64; ; )
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Borislav Petkov <bp@alien8.de>, Tejun Heo <tj@kernel.org>,
        tigran@aivazian.fsnet.co.uk, tglx@linutronix.de, mingo@elte.hu,
        hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
References: <4E88B5E0.6080503@linux.vnet.ibm.com> <20111004134653.GC3148@gere.osrc.amd.com> <20111004171415.GB3915@gere.osrc.amd.com>
In-Reply-To: <20111004171415.GB3915@gere.osrc.amd.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201110042149.30524.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 04, 2011, Borislav Petkov wrote:
> On Tue, Oct 04, 2011 at 03:46:53PM +0200, Borislav Petkov wrote:
> > On Tue, Oct 04, 2011 at 06:45:12PM +0530, Srivatsa S. Bhat wrote:
> > > I would like to propose a modified solution to the problem:
> > > 
> > > Taking a CPU offline:
> > > * Upon a CPU_DEAD notification, just like the code originally did, we free
> > >   the kernel's copy of the microcode and invalidate it. So no changes here.
> > >  
> > > Bringing a CPU online:
> > > * When a CPU_ONLINE or CPU_ONLINE_FROZEN notification is received, 
> > >   a. If the userspace is not frozen, we request microcode from userspace and
> > >      apply it to the cpu.
> > > 
> > >   b. However if we find that the userspace is frozen at that moment, we defer
> > >      applying microcode now and register a callback function to be executed
> > >      immediately when the userspace gets thawed. This callback function would
> > >      request microcode from userspace and apply it to the cpu.
> > 
> > No need for that if we can drop the whole re-requesting of ucode on
> > CPU_ONLINE* (see my other mail). Let me run some tests before though.
> 
> Ok, it looks good. I had one issue with what happens when there's no
> ucode image but the ucode driver is a bit-hmm... and that case actually
> magically works.
> 
> So you can have my Acked- and Tested-by:'s for the AMD side - you still
> need to test it on Intel with both microcode_ctl and the module un- and
> loading so that you make sure you're not introducing regressions, if you
> haven't done so yet, of course.

Cool, thanks.

I'd like to hear a voice from the Intel side too.

Thanks,
Rafael
