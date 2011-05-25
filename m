Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab1EYKvB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 06:51:01 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:58302 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794Ab1EYKvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 06:51:00 -0400
Date: Wed, 25 May 2011 12:50:57 +0200
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Borislav Petkov <bp@alien8.de>, Andi Kleen <andi@firstfloor.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/3] x86, intel: Output microcode revision
Message-ID: <20110525105057.GA21830@gere.osrc.amd.com>
References: <1306278210-18285-1-git-send-email-andi@firstfloor.org>
 <20110525065451.GC429@elte.hu>
 <20110525080042.GA27183@liondog.tnic>
 <20110525090501.GA28500@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110525090501.GA28500@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 11:05:01AM +0200, Ingo Molnar wrote:
> > Frankly, I'm not even 100% persuaded this is needed. The coretemp.c 
> > jump-through-hoops to get the ucode revision is maybe the only case 
> > that warrants adding that field to /proc/cpuinfo.

> I've often wondered whether the CPU involved in a particular bugreport
> has the latest microcode installed.

Ok, that's a good point, actually.

> Sure we have /sys/devices/system/cpu/cpuN/microcode/version, but
> that's both privileged to get

Not only that but you have to load the ucode driver to be able to read
it. /proc/cpuinfo looks like the easiest and most generic place.

> and also has to be asked for separately.

yes.

> 
> Arguably the microcode version is a natural extension to the existing 
> family/model/stepping sequence:
> 
>  cpu family	: 6
>  model		: 26
>  stepping	: 5
> 
> We'd now see:
> 
>  cpu family	: 6
>  model		: 26
>  stepping	: 5
>  ucode_version  : 17
> 
> Where 'stepping' is a hardware revison number and 'ucode_version' is 
> a dual software/hw revision number.

Right.

Btw, can we dump the ucode version in hex since ours are much easier to
read that way:

[86483.770976] microcode: CPU0: patch_level=0x010000c4
[86483.826987] microcode: CPU1: patch_level=0x010000c4
[86483.835071] microcode: CPU2: patch_level=0x010000c4
...

I guess for Intel the ucode version format won't matter that much.

> > > > @@ -111,6 +111,8 @@ struct cpuinfo_x86 {
> > > >  	/* Index into per_cpu list: */
> > > >  	u16			cpu_index;
> > > >  #endif
> > > > +	/* CPU update signature */
> > > > +	u32			x86_cpu_update;
> > > 
> > > This should be cpu_microcode_version instead. We already know its x86 so the 
> > > x86_ prefix is superfluous. 'cpu_update' is also rather ambigious and does not 
> > > describe much.
> > 
> > Or shorter: 'cpu_ucode_version'.
> 
> We already know it's a cpu data structure, since it's called 'struct 
> cpuinfo_x86' and the local variable is named 'c' which is the typical 
> shortcut for that data structure.
> 
> so c->ucode_version is the right name here.

even better.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
