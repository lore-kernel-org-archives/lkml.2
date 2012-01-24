Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047Ab2AXWbd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 17:31:33 -0500
Received: from mga03.intel.com ([143.182.124.21]:49155 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767Ab2AXWbb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 17:31:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="59647615"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Ben Hutchings <bhutchings@solarflare.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Chen Gong <gong.chen@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>, x86 <x86@kernel.org>
Subject: RE: [PATCH v5 03/12] x86/topology.c: Support functions for CPU0
 online/offline
Thread-Topic: [PATCH v5 03/12] x86/topology.c: Support functions for CPU0
 online/offline
Thread-Index: AQHM0IXsBQT5wJDS+kaktsKKH5Ad3ZYPz3EAgAxdKjA=
Date: Tue, 24 Jan 2012 22:31:23 +0000
Message-ID: <3E5A0FA7E9CA944F9D5414FEC6C7122003473E@ORSMSX105.amr.corp.intel.com>
References: <1326301493-28760-1-git-send-email-fenghua.yu@intel.com>
	 <1326301493-28760-4-git-send-email-fenghua.yu@intel.com>
 <1326735308.3065.29.camel@bwh-desktop>
In-Reply-To: <1326735308.3065.29.camel@bwh-desktop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q0OMVa3k032115


> On Wed, 2012-01-11 at 09:04 -0800, Fenghua Yu wrote:
> > From: Fenghua Yu <fenghua.yu@intel.com>
> >
> > If CONFIG_BOOTPARAM_HOTPLUG_CPU is turned on, CPU0 hotplug feature is
> enabled
> > by default.
> >
> > If CONFIG_BOOTPARAM_HOTPLUG_CPU is not turned on, CPU0 hotplug
> feature is not
> > enabled by default. The kernel parameter cpu0_hotplug can enable CPU0
> hotplug
> > feature at boot.
> [...]
> >  int __ref arch_register_cpu(int num)
> >  {
> >  	/*
> > -	 * CPU0 cannot be offlined due to several
> > -	 * restrictions and assumptions in kernel. This basically
> > -	 * doesn't add a control file, one cannot attempt to offline
> > -	 * BSP.
> > +	 * Two known BSP/CPU0 dependencies: Resume from suspend/hibernate
> > +	 * depends on BSP. PIC interrupts depend on BSP.
> >  	 *
> > -	 * Also certain PCI quirks require not to enable hotplug control
> > -	 * for all CPU's.
> > +	 * If the BSP depencies are under control, one can tell kernel to
> > +	 * enable BSP hotplug. This basically adds a control file and
> > +	 * one can attempt to offline BSP.
> >  	 */
> > -	if (num)
> > +	if (num || cpu0_hotpluggable)
> >  		per_cpu(cpu_devices, num).cpu.hotpluggable = 1;
> >
> >  	return register_cpu(&per_cpu(cpu_devices, num).cpu, num);
> 
> This change belongs at the end of the series.  It should not be
> possible
> to enable CPU0 hotplug until after the hotplug logic can do it
> correctly, and this might break bisection.

Quote from https://www.linux.com/how-to-participate-in-the-linux-community
"It can be tempting to add a whole new infrastructure with a series of patches, but to leave that infrastructure unused until the final patch in the series enables the whole thing. This temptation should be avoided if possible; if that series adds regressions, bisection will finger the last patch as the one which caused the problem, even though the real bug is elsewhere. Whenever possible, a patch which adds new code should make that code active immediately."

So this patch currently is in the right place in the patch set unless I miss something.

Thanks.

-Fenghua
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
