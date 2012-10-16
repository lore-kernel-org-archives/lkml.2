Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846Ab2JPSnk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 14:43:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:9209 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755765Ab2JPSni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 14:43:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,595,1344236400"; 
   d="scan'208";a="234662583"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Arjan Dan De Ven <arjan@linux.intel.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Srivatssa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Chen Gong <gong.chen@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>, x86 <x86@kernel.org>
Subject: RE: [PATCH v9 03/12] x86, topology: Don't offline CPU0 if any PIC
 irq can not be migrated out of it
Thread-Topic: [PATCH v9 03/12] x86, topology: Don't offline CPU0 if any PIC
 irq can not be migrated out of it
Thread-Index: AQHNqJme6odeecU3d0O8w0KwtfALZpe8pGSA//+lj7A=
Date: Tue, 16 Oct 2012 18:43:36 +0000
Message-ID: <3E5A0FA7E9CA944F9D5414FEC6C7122030B16447@ORSMSX105.amr.corp.intel.com>
References: <1350058189-6769-1-git-send-email-fenghua.yu@intel.com>
 <1350058189-6769-4-git-send-email-fenghua.yu@intel.com>
 <20121016170310.GC12694@x1.osrc.amd.com>
In-Reply-To: <20121016170310.GC12694@x1.osrc.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9GIhjkE032555

> On Fri, Oct 12, 2012 at 09:09:40AM -0700, Fenghua Yu wrote:
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
> >
> > Currently the feature is supported on Intel platforms only.
> >
> > Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> > ---
> >  arch/x86/kernel/topology.c |   50
> +++++++++++++++++++++++++++++++++++++------
> 
> It is just me or is this whole change better suited for
> 
> arch/x86/kernel/cpu/topology.c
> 
> where cpu-specific stuff lives anyway?

arch/x86/kernel/cpu/topology.c doesn't contain CPU hotplug hooks. To place
the BSP patchset in this file, other existing CPU hotplug code should
be moved to this file as well. Apparently that's not this patchset's task.

Thanks.

-Fenghua
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
