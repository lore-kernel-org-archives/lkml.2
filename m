Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967Ab1KGT5k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 14:57:40 -0500
Received: from mga02.intel.com ([134.134.136.20]:22297 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348Ab1KGT5j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 14:57:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="71956030"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Date: Mon, 7 Nov 2011 11:57:37 -0800
Subject: RE: [PATCH 7/9] x86/topology.c: Support functions for BSP
 online/offline
Thread-Topic: [PATCH 7/9] x86/topology.c: Support functions for BSP
 online/offline
Thread-Index: Acyb/9LsOrTbarqIT/CTAK3HpRGCygBhs9XA
Message-ID: <493994B35A117E4F832F97C4719C4C040194B7C59B@orsmsx505.amr.corp.intel.com>
References: <1320444241-834-1-git-send-email-fenghua.yu@intel.com>
 <1320444241-834-8-git-send-email-fenghua.yu@intel.com>
 <4EB5A705.4030008@linux.vnet.ibm.com>
In-Reply-To: <4EB5A705.4030008@linux.vnet.ibm.com>
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

> > +static int bsp_hotpluggable;
> > +
> > +static int __init enable_bsp_hotplug(char *str)
> > +{
> > +	bsp_hotpluggable = 1;
> > +	return 0;
> 
> Any reason why you return 0 here? Most code I have seen similar to this,
> return 1. I understand that anything declared using early_param() would
> generate a warning if it returns non-zero, but I am not exactly sure
> about how it behaves with __setup(). Kindly give this some thought.

You're right. This function should return 1 here. The parameter setup function returns 1 for success and 0 for failure. The return value is checked in obsolete_checksetup():
                        } else if (p->setup_func(line + n))
                                return 1;

I will change this return value to 1 in the next version of the patch set.

BTW, some places in the current upstream do return 0 for success and return an error number for failure. Maybe we need to clean up them.

Thanks.

-Fenghua

