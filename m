Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533Ab1KGVC5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 16:02:57 -0500
Received: from mga09.intel.com ([134.134.136.24]:1457 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399Ab1KGVC4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 16:02:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="72077237"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Len Brown <lenb@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        H Peter Anvin <hpa@zytor.com>,
        Zwane Mwaikambo <zwane@arm.linux.org.uk>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Mon, 7 Nov 2011 13:02:54 -0800
Subject: RE: [PATCH 6/8] x86, topology.c: Enable CPU0 online/offline
Thread-Topic: [PATCH 6/8] x86, topology.c: Enable CPU0 online/offline
Thread-Index: Acyc8oQXAL1Ap6LbRC2Z+Xj+LDqMUAAmdxHQ
Message-ID: <493994B35A117E4F832F97C4719C4C040194B7C64E@orsmsx505.amr.corp.intel.com>
References: <1317832759-10223-1-git-send-email-fenghua.yu@intel.com>
 <1317832759-10223-7-git-send-email-fenghua.yu@intel.com>
 <alpine.LFD.2.02.1110052113370.18778@ionos>
 <493994B35A117E4F832F97C4719C4C04013E1A6784@orsmsx505.amr.corp.intel.com>
 <4EB73E36.1040602@kernel.org>
In-Reply-To: <4EB73E36.1040602@kernel.org>
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

> >> And you forgot poweroff and reboot, which have similar dependencies
> on
> >> some machines. That whole low level ACPI stuff is sensitive.
> >
> > I tested poweroff, shutdown, and reboot with various reboot_type on a
> few different platforms. I haven't seen poweroff and reboot issues
> after CPU0 is offline.
> >
> > Do you have specific platforms that I can test poweroff and reboot
> dependency on CPU0?
> 
> > Or we just assume there are some platforms out there that depend on
> CPU0 for poweroff/reboot?
> 
> A classic Linux/ACPI failure happened when HT first shipped.
> Some platforms stopped powering off or rebooting 50% of the time.
> 
> It turned out that SMM on those machines assumed
> it would be triggered from CPU0 and not CPU1.
> 
> the original code should have worked, of course,
> and most of the time it did -- but some systems broke.
> The same will probably happen here.

Thanks for your info on poweroff/reboot and CPU0.

I wrote a statement in the cpu-hotplug.txt doc in newer patch set:

"It's said poweroff/reboot may depend on BSP on some machines although I haven't
seen any poweroff/reboot failure so far after BSP is offline on a few tested
machines."
"Please let me know if you know or see any other dependencies of BSP."

If we know a specific model of machine can't poweroff/reboot after CPU0 is offline, I can do something like put that machine in a black list in the poweroff/reboot path to let user online CPU0 before poweroff/reboot.

Hopefully this is a temp OK solution for the patch set to get in kernel and let people report any poweroff/reboot or any other dependencies on CPU0.

Thanks.

-Fenghua
