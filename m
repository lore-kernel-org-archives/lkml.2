Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988Ab1EYJFX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 05:05:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54676 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299Ab1EYJFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 05:05:22 -0400
Date: Wed, 25 May 2011 11:05:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <bp@alien8.de>, Andi Kleen <andi@firstfloor.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/3] x86, intel: Output microcode revision
Message-ID: <20110525090501.GA28500@elte.hu>
References: <1306278210-18285-1-git-send-email-andi@firstfloor.org>
 <20110525065451.GC429@elte.hu>
 <20110525080042.GA27183@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110525080042.GA27183@liondog.tnic>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@alien8.de> wrote:

> On Wed, May 25, 2011 at 08:54:51AM +0200, Ingo Molnar wrote:
> > 
> > * Andi Kleen <andi@firstfloor.org> wrote:
> > 
> > > From: Andi Kleen <ak@linux.intel.com>
> > > 
> > > I got a request to make it easier to determine the microcode update level
> > > on Intel CPUs. This patch adds a new "cpu update" field to /proc/cpuinfo,
> > > which I added at the end to minimize impact on parsers.
> > 
> > Agreed, that is a good idea, adding this to cpuinfo makes sense.
> 
> Frankly, I'm not even 100% persuaded this is needed. The coretemp.c 
> jump-through-hoops to get the ucode revision is maybe the only case 
> that warrants adding that field to /proc/cpuinfo.

I've often wondered whether the CPU involved in a particular 
bugreport has the latest microcode installed.

Sure we have /sys/devices/system/cpu/cpuN/microcode/version, but 
that's both privileged to get and also has to be asked for 
separately.

Arguably the microcode version is a natural extension to the existing 
family/model/stepping sequence:

 cpu family	: 6
 model		: 26
 stepping	: 5

We'd now see:

 cpu family	: 6
 model		: 26
 stepping	: 5
 ucode_version  : 17

Where 'stepping' is a hardware revison number and 'ucode_version' is 
a dual software/hw revision number.

> > > @@ -111,6 +111,8 @@ struct cpuinfo_x86 {
> > >  	/* Index into per_cpu list: */
> > >  	u16			cpu_index;
> > >  #endif
> > > +	/* CPU update signature */
> > > +	u32			x86_cpu_update;
> > 
> > This should be cpu_microcode_version instead. We already know its x86 so the 
> > x86_ prefix is superfluous. 'cpu_update' is also rather ambigious and does not 
> > describe much.
> 
> Or shorter: 'cpu_ucode_version'.

We already know it's a cpu data structure, since it's called 'struct 
cpuinfo_x86' and the local variable is named 'c' which is the typical 
shortcut for that data structure.

so c->ucode_version is the right name here.

Thanks,

	Ingo
