Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932488Ab1KQQAp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 11:00:45 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:18357 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932331Ab1KQQAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 11:00:43 -0500
Date: Thu, 17 Nov 2011 11:00:21 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: HAYASAKA Mitsuo <mitsuo.hayasaka.hu@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Randy Dunlap <rdunlap@xenotime.net>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC PATCH 3/5] x86: add a sysctl parameter to panic on stack
 overflow
Message-ID: <20111117160021.GC6008@phenom.dumpdata.com>
References: <20111107055108.7928.89454.stgit@ltc219.sdl.hitachi.co.jp>
 <20111107055301.7928.91628.stgit@ltc219.sdl.hitachi.co.jp>
 <20111110195538.GB22646@phenom.dumpdata.com>
 <4EC4B38B.2010301@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EC4B38B.2010301@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4EC52F9E.00BC,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 17, 2011 at 04:11:07PM +0900, HAYASAKA Mitsuo wrote:
> Hi Konrad,
> 
> >> diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
> >> index 530cfd0..d720813 100644
> >> --- a/arch/x86/kernel/irq_64.c
> >> +++ b/arch/x86/kernel/irq_64.c
> >> @@ -20,6 +20,8 @@
> >>  #include <asm/idle.h>
> >>  #include <asm/apic.h>
> >>  
> >> +int sysctl_panic_on_stackoverflow;
> > __read_mostly
> 
> I don't mind if I add __read_mostly here, but I think it's not
> necessary because this variable is seldom read as well.

The definition of __read_mostly is that it moves this variable to a cold cache area.
Which is what you want.

> 
> 
> >> diff --git a/kernel/sysctl_binary.c b/kernel/sysctl_binary.c
> >> index 6318b51..24fc654 100644
> >> --- a/kernel/sysctl_binary.c
> >> +++ b/kernel/sysctl_binary.c
> >> @@ -137,6 +137,7 @@ static const struct bin_table bin_kern_table[] = {
> >>  	{ CTL_INT,	KERN_COMPAT_LOG,		"compat-log" },
> >>  	{ CTL_INT,	KERN_MAX_LOCK_DEPTH,		"max_lock_depth" },
> >>  	{ CTL_INT,	KERN_PANIC_ON_NMI,		"panic_on_unrecovered_nmi" },
> >> +	{ CTL_INT,	KERN_PANIC_ON_STACKOVERFLOW,	"panic_on_stackoverflow" },
> > This shouldn't be wrapped in the #ifdef?
> >
> 
> It seems that we do not need to add this entry to bin_kern_table[]
> according to the following information and patch series:
> 
> [Removing binary sysctl]
> 	http://lwn.net/Articles/361453/
> 
> [Removal of binary sysctl support]
> 	http://lwn.net/Articles/361001/
> 
> So, I'm going to remove this changes for sysctl.h and sysctl_binary.c.

<nods>
