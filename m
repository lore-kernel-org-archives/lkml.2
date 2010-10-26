Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049Ab0JZQlZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 12:41:25 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:42065 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123Ab0JZQlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 12:41:24 -0400
Date: Tue, 26 Oct 2010 18:41:34 +0200
From: Borislav Petkov <bp@amd64.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: Clocksource tsc unstable (delta = -8589361717 ns) in current
 git
Message-ID: <20101026164134.GA2449@kryptos.osrc.amd.com>
References: <20101026112052.GA1672@arch.trippelsdorf.de>
 <20101026131843.GC17852@aftab>
 <20101026135808.GB1672@arch.trippelsdorf.de>
 <1288103930.15336.321.camel@twins>
 <alpine.LFD.2.00.1010261745260.3115@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1010261745260.3115@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>
Date: Tue, Oct 26, 2010 at 05:46:00PM +0200

> On Tue, 26 Oct 2010, Peter Zijlstra wrote:
> 
> > On Tue, 2010-10-26 at 15:58 +0200, Markus Trippelsdorf wrote:
> > > > 
> > > > This is strange, tsc is actually stable on your F10h revC.
> > > 
> > > Yes. constant_tsc is among the CPU flags. 
> >  
> > constant_tsc only means the TSC is not affected by cpu freq changes.
> > 
> > It has zero relevance to cross-cpu sync of the TSC. The clocksource
> > stuff requires your TSC to be synchronous over all your CPUs.
> 
> That and not affected by C-States either.

Well, F10h TSC is P- and C-state invariant - I've never seen any systems
not passing the TSC sync check at boot so far. And if there are still
systems where this is not the case or you see the TSC not behaving, make
sure to tell me about it.

Besides, the TSC calibration with PIT seems to function ok, and the
"Detected " line shows reasonable core frequency. FWIW, I have a similar
configuration here and will run latest -git on it too to check.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
