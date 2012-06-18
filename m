Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752292Ab2FRMXp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 08:23:45 -0400
Received: from www.linutronix.de ([62.245.132.108]:49436 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111Ab2FRMXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 08:23:44 -0400
Date: Mon, 18 Jun 2012 14:23:36 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chen Gong <gong.chen@linux.intel.com>
cc: tony.luck@intel.com, borislav.petkov@amd.com, x86@kernel.org,
        peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] tmp patch to fix hotplug issue in CMCI storm
In-Reply-To: <4FDEFF53.9040902@linux.intel.com>
Message-ID: <alpine.LFD.2.02.1206181422420.3086@ionos>
References: <alpine.LFD.2.02.1206151122140.3086@ionos> <1340001930-12519-1-git-send-email-gong.chen@linux.intel.com> <alpine.LFD.2.02.1206180952070.3086@ionos> <4FDEFF53.9040902@linux.intel.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-918376667-1340022217=:3086"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-918376667-1340022217=:3086
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Mon, 18 Jun 2012, Chen Gong wrote:
> 于 2012/6/18 16:00, Thomas Gleixner 写道:
> > On Mon, 18 Jun 2012, Chen Gong wrote:
> > > index 92d8b5c..0493525 100644
> > > --- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
> > > +++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
> > > @@ -40,6 +40,7 @@ static DEFINE_RAW_SPINLOCK(cmci_discover_lock);
> > >   static DEFINE_PER_CPU(unsigned long, cmci_time_stamp);
> > >   static DEFINE_PER_CPU(unsigned int, cmci_storm_cnt);
> > >   static DEFINE_PER_CPU(unsigned int, cmci_storm_state);
> > > +static DEFINE_PER_CPU(unsigned long, cmci_storm_hcpu_status);
> > 
> > Why do you insist on having another status variable, which does
> > actually nothing than obfuscate the code?
> > 
> > Look at the usage sites:
> > 
> > >   		__this_cpu_write(cmci_storm_state, CMCI_STORM_SUBSIDED);
> > > +		__this_cpu_write(cmci_storm_hcpu_status,
> > > CMCI_STORM_HCPU_NONE);
> 
> Because here I can't substitute CMCI_STORM_HCPU_NONE with
> CMCI_STORM_SUBSIDED. If so, the status is chaos.

Have you actually read what I wrote later? You do not neeed that extra
state, period.

--8323328-918376667-1340022217=:3086--
