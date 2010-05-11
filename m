Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175Ab0EKTua (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 15:50:30 -0400
Received: from www.tglx.de ([62.245.132.106]:36808 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939Ab0EKTu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 15:50:28 -0400
Date: Tue, 11 May 2010 21:50:10 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
cc: Jacob Pan <jacob.jun.pan@linux.intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       "Du, Alek" <alek.du@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "Tang, Feng" <feng.tang@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 3/8] x86/apic: allow use of lapic timer early calibration
 result
In-Reply-To: <43F901BD926A4E43B106BF17856F0755A74B2827@orsmsx508.amr.corp.intel.com>
Message-ID: <alpine.LFD.2.00.1005112146180.3401@localhost.localdomain>
References: <1273254108-3234-1-git-send-email-jacob.jun.pan@linux.intel.com> <1273254108-3234-4-git-send-email-jacob.jun.pan@linux.intel.com> <alpine.LFD.2.00.1005111514471.3401@localhost.localdomain>
 <43F901BD926A4E43B106BF17856F0755A74B2827@orsmsx508.amr.corp.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jacob,

On Tue, 11 May 2010, Pan, Jacob jun wrote:

> Thanks for the review.
> 
> > >
> > > lapic timer calibration can be combined with tsc in platform specific
> > > calibration functions. if such calibration result is obtained early,
> > > we can skip the redundent calibration loops.
> > 
> > I'd rather move lapic calibration into TSC calibration in general as
> > we do the same thing twice for no good reason.
> > 
> > That needs some code restructuring, but that's worth it.
> > 
> I am trying to avoid the risks of completely remove the current lapic 
> calibration code since there are so many platforms with different timer
> options. And I don't understand things like why pm timer is preferred.
> Why not use the rating in clocksource?

We do not have access to the clocksource at that point. But we do a
calibration loop for TSC and for lapic timer. There is no reason why
we can't do that in one go.
 
> > Aside of my general objection it'd be not a good idea to make this
> > global w/o renaming it to something sensible like
> > lapic_timer_frequency.
> > 
> perhaps, the calibration data can directly be assigned to lapic timer
> clock_event_device.mult? There is no need for the device specific result
> scale (e.g. bus clocks per tick)

No. That needs an accessor function.

Thanks,

	tglx
