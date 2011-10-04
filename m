Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932943Ab1JDROS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 13:14:18 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:35855 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932204Ab1JDROR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 13:14:17 -0400
Date: Tue, 4 Oct 2011 19:14:15 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Borislav Petkov <bp@alien8.de>, Tejun Heo <tj@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, tigran@aivazian.fsnet.co.uk,
        tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [BUGFIX][PATCH] Freezer, CPU hotplug, x86 Microcode: Fix task
 freezing failures
Message-ID: <20111004171415.GB3915@gere.osrc.amd.com>
References: <4E88B5E0.6080503@linux.vnet.ibm.com>
 <20111002195023.GC31799@mtj.dyndns.org>
 <4E88C3D4.2020300@linux.vnet.ibm.com>
 <20111003004051.GD31799@mtj.dyndns.org>
 <4E894D75.808@linux.vnet.ibm.com>
 <20111003084754.GB4411@liondog.tnic>
 <20111004071508.GA15637@dhcp-172-17-108-109.mtv.corp.google.com>
 <4E8B06E0.2090501@linux.vnet.ibm.com>
 <20111004134653.GC3148@gere.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111004134653.GC3148@gere.osrc.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 04, 2011 at 03:46:53PM +0200, Borislav Petkov wrote:
> On Tue, Oct 04, 2011 at 06:45:12PM +0530, Srivatsa S. Bhat wrote:
> > I would like to propose a modified solution to the problem:
> > 
> > Taking a CPU offline:
> > * Upon a CPU_DEAD notification, just like the code originally did, we free
> >   the kernel's copy of the microcode and invalidate it. So no changes here.
> >  
> > Bringing a CPU online:
> > * When a CPU_ONLINE or CPU_ONLINE_FROZEN notification is received, 
> >   a. If the userspace is not frozen, we request microcode from userspace and
> >      apply it to the cpu.
> > 
> >   b. However if we find that the userspace is frozen at that moment, we defer
> >      applying microcode now and register a callback function to be executed
> >      immediately when the userspace gets thawed. This callback function would
> >      request microcode from userspace and apply it to the cpu.
> 
> No need for that if we can drop the whole re-requesting of ucode on
> CPU_ONLINE* (see my other mail). Let me run some tests before though.

Ok, it looks good. I had one issue with what happens when there's no
ucode image but the ucode driver is a bit-hmm... and that case actually
magically works.

So you can have my Acked- and Tested-by:'s for the AMD side - you still
need to test it on Intel with both microcode_ctl and the module un- and
loading so that you make sure you're not introducing regressions, if you
haven't done so yet, of course.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
