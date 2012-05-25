Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576Ab2EYCrZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 22:47:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:13906 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753647Ab2EYCrY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 22:47:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="157055036"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: David Miller <davem@davemloft.net>
CC: "mingo@elte.hu" <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Subject: RE: [PATCH] x86/copy_user_generic: Optimize copy_user_generic with
 CPU erms feature
Thread-Topic: [PATCH] x86/copy_user_generic: Optimize copy_user_generic with
 CPU erms feature
Thread-Index: AQHNOhYcYZziRMKO70GjI/IquIcO/ZbaMqaA//+XTrA=
Date: Fri, 25 May 2012 02:47:22 +0000
Message-ID: <3E5A0FA7E9CA944F9D5414FEC6C712200771A972@ORSMSX105.amr.corp.intel.com>
References: <1337908785-14015-1-git-send-email-fenghua.yu@intel.com>
 <20120524.215019.1013474044821595274.davem@davemloft.net>
In-Reply-To: <20120524.215019.1013474044821595274.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: David Miller [mailto:davem@davemloft.net]
> Sent: Thursday, May 24, 2012 6:50 PM
> From: "Fenghua Yu" <fenghua.yu@intel.com>
> Date: Thu, 24 May 2012 18:19:45 -0700
> 
> > According to Intel 64 and IA-32 SDM and Optimization Reference
> > Manual, beginning with Ivybridge, REG string operation using MOVSB
> > and STOSB can provide both flexible and high-performance REG string
> > operations in cases like memory copy.  Enhancement availability is
> > indicated by CPUID.7.0.EBX[9] (Enhanced REP MOVSB/ STOSB).
> 
> How does the cpu do overlap detection?
> 
> If the cpu does overlap detection on sub-pagesize bits, performance
> will unnecessarily suffer under such circumstances.

Are you talking about memory overlap between source and destination? There is no overlap between these two areas in copy_user case because one area is in user space and another one is in kernel space.

In overlap case, it's software that detects overlap and sets backward copy. I don't see backward rep movsb performance degradation from my measurement.

Thanks.

-Fenghua
