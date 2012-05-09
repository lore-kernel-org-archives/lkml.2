Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab2EIHBF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 03:01:05 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57689 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800Ab2EIHBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 03:01:03 -0400
Date: Wed, 9 May 2012 09:00:58 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        "H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuahkhan@gmail.com>,
        mingo@redhat.com, tglx@linutronix.de, tigran@aivazian.fsnet.co.uk,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] x86: kernel/microcode_core.c simple_strtoul
 cleanup
Message-ID: <20120509070058.GA19853@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@kernel.org>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuahkhan@gmail.com>,
	mingo@redhat.com, tglx@linutronix.de, tigran@aivazian.fsnet.co.uk,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1336324264.2897.9.camel@lorien2>
 <20120507104943.GA3896@x1.osrc.amd.com>
 <4FA815E3.1030101@zytor.com>
 <20120507211612.GA19700@liondog.tnic>
 <20120508012341.GA27000@khazad-dum.debian.net>
 <20120508040009.GB30652@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120508040009.GB30652@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2012 at 06:00:10AM +0200, Ingo Molnar wrote:
> 
> * Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:
> 
> > > Of course, one can iterate over each core in a shell-loop 
> > > and write into the reload file to reload ucode after having 
> > > updated the ucode image in /lib/firmware but removing and 
> > > then modprobing the module is shorter :-)
> > 
> > Can we PLEASE fix it properly by adding a new node (which is 
> > _not_ per-cpu) that requests the microcode core to refresh all 
> > cpus?

Ok, where do you want to have it:

$ find /sys -iname "microcode"
/sys/bus/platform/devices/microcode
/sys/devices/system/cpu/cpu0/microcode
/sys/devices/system/cpu/cpu1/microcode
/sys/devices/virtual/misc/microcode
/sys/devices/platform/microcode
/sys/class/misc/microcode
/sys/module/microcode

I'm all for the level at

/sys/devices/system/cpu/

where CPU-related stuff can go in - not per-CPU but per whole system.
Ingo?

> > Preferably by invalidating the microcode cache, THEN fetching each
> > required microcode just once for the first core that needs it, and
> > caching it for use the other cores.

That should be easy, the most part is already there.

> > You can leave the (IMHO mostly useless) per-cpu sysfs nodes alone,
> > so as to not break ABI, or deprecate them for an year or something.

Yeah, about that, what is not breaking the ABI? Having the sysfs node but
reading/writing it returns -E<something>, having the sysfs node and
reading/writing it does nothing, or...?

> > I *do NOT* want to rmmod crap in a production server to update
> > microcode. And I want to be able to support static-compiled
> > microcode.

I'd need this more explained, why?

If by "static-compiled microcode" you mean the microcode.ko module
should be built-in that can't fly because for request_firmware we need
userspace to actually find the ucode image.

Thanks.

-- 
Regards/Gruss,
    Boris.
