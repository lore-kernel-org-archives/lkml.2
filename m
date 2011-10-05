Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935473Ab1JEUZQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 16:25:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:2109 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935463Ab1JEUZO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 16:25:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,493,1312182000"; 
   d="scan'208";a="70682040"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>, H Peter Anvin <hpa@zytor.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Wed, 5 Oct 2011 13:25:11 -0700
Subject: RE: [PATCH 8/8] kernel/cpu.c: Define bsp_hotpluggable variable
Thread-Topic: [PATCH 8/8] kernel/cpu.c: Define bsp_hotpluggable variable
Thread-Index: AcyDlIcSL0uv1x14Rk+9QZewItcqEwABsMPQ
Message-ID: <493994B35A117E4F832F97C4719C4C040136F7CCB1@orsmsx505.amr.corp.intel.com>
References: <1317832759-10223-1-git-send-email-fenghua.yu@intel.com>
 <1317832759-10223-9-git-send-email-fenghua.yu@intel.com>
 <alpine.LFD.2.02.1110052122240.18778@ionos>
In-Reply-To: <alpine.LFD.2.02.1110052122240.18778@ionos>
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

> -----Original Message-----
> From: Thomas Gleixner [mailto:tglx@linutronix.de]
> Sent: Wednesday, October 05, 2011 12:25 PM
> To: Yu, Fenghua
> Cc: Ingo Molnar; H Peter Anvin; Zwane Mwaikambo; Luck, Tony; Mallick,
> Asit K; Siddha, Suresh B; Len Brown; linux-kernel
> Subject: Re: [PATCH 8/8] kernel/cpu.c: Define bsp_hotpluggable variable
> 
> On Wed, 5 Oct 2011, Fenghua Yu wrote:
> 
> > From: Fenghua Yu <fenghua.yu@intel.com>
> >
> > This gloable variable controls BSP (aka CPU0) hotplug. If set, BSP is
> > hotpluggable. By default, it's 0. On X86, kernel option
> bsp_hotpluggable sets
> > the variable as 1.
> 
> .... and on !x86 its just pointless.

I'll change the variable to an inline function which returns bsp_hotpluggable on x86 and is empty function on !x86.

> 
> I have yet to see a justification for that whole cpu0 unplugging
> business.
> 
> If there is a real reason that this is desireable, then ALL cpu0
> assumptions in arch/x86 need to be cleaned up and fixed.

I can think of two reasons for bsp offline/online:

1. RAS needs the feature. If socket0 needs to be hotplugged for any reason (any thread on socket0 is bad, shared cache issue, uncore issue, etc), CPU0 is required to be offlined.
2. CPU0 is symmetrical to other CPU's. There is no specific reason why it shouldn't be offlined except BIOS requirements.

Thanks.

-Fenghua
