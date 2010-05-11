Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532Ab0EKUq5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 16:46:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:9376 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752074Ab0EKUq4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 16:46:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,210,1272870000"; 
   d="scan'208";a="517058117"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: Jacob Pan <jacob.jun.pan@linux.intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       "Du, Alek" <alek.du@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "Tang, Feng" <feng.tang@intel.com>, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 11 May 2010 13:46:54 -0700
Subject: RE: [PATCH 3/8] x86/apic: allow use of lapic timer early
 calibration result
Thread-Topic: [PATCH 3/8] x86/apic: allow use of lapic timer early
 calibration result
Thread-Index: AcrxQzLcqd5aMUc2S6mcFSeCODB3bwABgleQ
Message-ID: <43F901BD926A4E43B106BF17856F0755A74B28D6@orsmsx508.amr.corp.intel.com>
References: <1273254108-3234-1-git-send-email-jacob.jun.pan@linux.intel.com>
 <1273254108-3234-4-git-send-email-jacob.jun.pan@linux.intel.com>
 <alpine.LFD.2.00.1005111514471.3401@localhost.localdomain>
 <43F901BD926A4E43B106BF17856F0755A74B2827@orsmsx508.amr.corp.intel.com>
 <alpine.LFD.2.00.1005112146180.3401@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1005112146180.3401@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> We do not have access to the clocksource at that point. But we do a
> calibration loop for TSC and for lapic timer. There is no reason why
> we can't do that in one go.
> 
I have a simple patch that uses HPET to calibrate both tsc and lapic timers in one
loop in native_calibrate_tsc(). Will send out for RFC.

The question I have is the reference clock used for calibrating those local timers,
PIT, HPET, PM timer how should they be ranked. Can we make those known freq
clocksource devices available at this point so that we can use the clocksource
abstraction and its ranking automatically?


> > > Aside of my general objection it'd be not a good idea to make this
> > > global w/o renaming it to something sensible like
> > > lapic_timer_frequency.
> > >
> > perhaps, the calibration data can directly be assigned to lapic timer
> > clock_event_device.mult? There is no need for the device specific
> result
> > scale (e.g. bus clocks per tick)
> 
> No. That needs an accessor function.
> 
Agreed, so you are ok with bypassing the existing calibration_result variable and use .mult
to carry the result?

