Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab1KCWrR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 18:47:17 -0400
Received: from mga03.intel.com ([143.182.124.21]:51209 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752786Ab1KCWrQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 18:47:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,452,1315206000"; 
   d="scan'208";a="70344796"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>, H Peter Anvin <hpa@zytor.com>,
        Zwane Mwaikambo <zwane@arm.linux.org.uk>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        Len Brown <lenb@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Thu, 3 Nov 2011 15:47:10 -0700
Subject: RE: [PATCH 6/8] x86, topology.c: Enable CPU0 online/offline
Thread-Topic: [PATCH 6/8] x86, topology.c: Enable CPU0 online/offline
Thread-Index: AcyDk+q7TcaTmsh+Rl6W+FDtfK3rcQW4dYTw
Message-ID: <493994B35A117E4F832F97C4719C4C04013E1A6784@orsmsx505.amr.corp.intel.com>
References: <1317832759-10223-1-git-send-email-fenghua.yu@intel.com>
 <1317832759-10223-7-git-send-email-fenghua.yu@intel.com>
 <alpine.LFD.2.02.1110052113370.18778@ionos>
In-Reply-To: <alpine.LFD.2.02.1110052113370.18778@ionos>
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

> > +	bsp_hotplug	[X86] BSP (aka CPU0) is hotpluggable.
> > +			Suspend/resume depends on BSP. It's said some PCI
> > +			quirks depend on BSP too. But not sure which quirks.
> 
> Right, not sure what breaks. Go ahead and watch your machine explode.
> 
> > +			If don't care the dependencies, you can turn on
> > +			bsp_ hotplug. Suspend will fail if BSP is offlined
> and
> > +			you need to online BSP before suspend/resume.
> 
> And you forgot poweroff and reboot, which have similar dependencies on
> some machines. That whole low level ACPI stuff is sensitive.

I tested poweroff, shutdown, and reboot with various reboot_type on a few different platforms. I haven't seen poweroff and reboot issues after CPU0 is offline.

Do you have specific platforms that I can test poweroff and reboot dependency on CPU0? Or we just assume there are some platforms out there that depend on CPU0 for poweroff/reboot?

Thanks.

-Fenghua 
