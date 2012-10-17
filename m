Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860Ab2JQAGQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 20:06:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:37013 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755692Ab2JQAGO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 20:06:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,595,1344236400"; 
   d="scan'208";a="234788718"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Arjan Dan De Ven <arjan@linux.intel.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Chen Gong <gong.chen@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>, x86 <x86@kernel.org>
Subject: RE: [PATCH v9 12/12] x86, topology: Debug CPU00 hotplug
Thread-Topic: [PATCH v9 12/12] x86, topology: Debug CPU00 hotplug
Thread-Index: AQHNqJmgIQc5pNFEs0GDL/Fd3/WvSJe8GfWAgACJoVA=
Date: Wed, 17 Oct 2012 00:06:12 +0000
Message-ID: <3E5A0FA7E9CA944F9D5414FEC6C7122030B196BC@ORSMSX105.amr.corp.intel.com>
References: <1350058189-6769-1-git-send-email-fenghua.yu@intel.com>
 <1350058189-6769-13-git-send-email-fenghua.yu@intel.com>
 <507D1F2F.1010006@linux.vnet.ibm.com>
In-Reply-To: <507D1F2F.1010006@linux.vnet.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +#ifdef CONFIG_DEBUG_HOTPLUG_CPU0
 > +	case PM_RESTORE_PREPARE:
> > +		/*
> > +		 * When system resumes from hibernation, online CPU0
> because
> > +		 * 1. it's required for resume and
> > +		 * 2. the CPU was online before hibernation
> > +		 */
> > +		if (!cpu_online(0))
> > +			_debug_hotplug_cpu(0, 1);
> 
> This won't work. CPU hotplug is disabled by cpu_hotplug_pm_callback()
> during
> PM_HIBERNATION_PREPARE and is enabled back only during
> PM_POST_HIBERNATION.
> 
> So calls to cpu_up() or cpu_down() will fail in the meantime.

The code works just fine.

You are talking about hibernation/suspend phase. This piece of
code is all about restore phase. Of course you can call cpu_up()
and cpu_down() during restore phase.

So there is no problem here.

Thanks.

-Fenghua

