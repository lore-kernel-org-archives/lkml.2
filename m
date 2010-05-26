Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941Ab0EZNEf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 09:04:35 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:18012 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578Ab0EZNEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 09:04:30 -0400
X-IronPort-AV: E=Sophos;i="4.53,304,1272844800"; 
   d="scan'208";a="98964"
Date: Wed, 26 May 2010 14:08:23 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       Don Dutile <ddutile@redhat.com>
Subject: Re: [PATCH 10/11] Support VIRQ_TIMER and pvclock on HVM
In-Reply-To: <4BFC31F5.9040806@goop.org>
Message-ID: <alpine.DEB.2.00.1005261342240.25605@kaball-desktop>
References: <alpine.DEB.2.00.1005241615300.25605@kaball-desktop> <1274725657-1149-10-git-send-email-stefano.stabellini@eu.citrix.com> <4BFC31F5.9040806@goop.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 May 2010, Jeremy Fitzhardinge wrote:
> On 05/24/2010 11:27 AM, Stefano Stabellini wrote:
> > Use the paravirtualized timer (VIRQ_TIMER) as timer and the
> > paravirtualized clock (pvclock) as wallclock on HVM domains too.
> >   
> 
> That's not quite correct.  There's the Xen clockevent driver, the Xen
> clocksource, and a distinct-but-related Xen notion of wallclock time. 
> In general, clocksources and wallclock don't have much direct
> relationship to each other.

Let me rephrase it:

use xen_vcpuop_clockevent instead of hpet and APIC timers as main
clockevent device on all vcpus, use the xen wallclock time as wallclock
instead of rtc and use xen_clocksource as clocksource.
The pv clock algorithm needs to work correctly for the xen_clocksource
and xen wallclock to be usable, only modern Xen versions offer a
reliable pv clock in HVM guests (XENFEAT_hvm_safe_pvclock).

> 
> > Any interaction with emulated hardware is not very fast, so using the
> > paravirtualized timer instead of the emulated hpet is defenitely a
> >   
> "definitely"
> 
> > performance improvement.
> >   
> 
> Are there accuracy/stability/precision improvements too?
> 

Using the hpet as clocksource means a VMEXIT every time we read/write to
the hpet mmio addresses, pvclock give us a better rating without
VMEXITs. Same goes for the xen wallclock and xen_vcpuop_clockevent.



