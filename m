Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758577Ab1FWBCF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 21:02:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:7742 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758222Ab1FWBCD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 21:02:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,409,1304319600"; 
   d="scan'208";a="21692286"
From: "Ma, Ling" <ling.ma@intel.com>
To: Andi Kleen <andi@firstfloor.org>
CC: "mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 23 Jun 2011 09:01:19 +0800
Subject: RE: [PATCH RFC] [x86] Optimize copy-page by reducing impact from HW
 prefetch
Thread-Topic: [PATCH RFC] [x86] Optimize copy-page by reducing impact from
 HW prefetch
Thread-Index: AcwxF/rYM0TRxMrxSvuA8d7AFo03jAAKKk7A
Message-ID: <C10D3FB0CD45994C8A51FEC1227CE22F239E8E4106@shsmsx502.ccr.corp.intel.com>
References: <1308351117-32452-1-git-send-email-ling.ma@intel.com>
 <m2fwn13a3u.fsf@firstfloor.org>
In-Reply-To: <m2fwn13a3u.fsf@firstfloor.org>
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

Yes, I also have tested 64bit atom, it got 11.6% improvement.
Because older CPU almost all use prefetch-next-line mechanism, the patch should be useful to them.

Thanks
Ling
> -----Original Message-----
> From: Ma, Ling
> Sent: Monday, June 20, 2011 11:43 AM
> To: Ma, Ling; mingo@elte.hu
> Cc: hpa@zytor.com; tglx@linutronix.de; linux-kernel@vger.kernel.org
> Subject: RE: [PATCH RFC V2] [x86] Optimize copy-page by reducing impact
> from HW prefetch
> 
> New experiment shows, for 4096 bytes no improvement on snb,
> 10~15% improvement on Core2, 11.6% improvement on 64bit atom.
> 
> Thanks
> Ling

> -----Original Message-----
> From: Andi Kleen [mailto:andi@firstfloor.org]
> Sent: Thursday, June 23, 2011 4:06 AM
> To: Ma, Ling
> Cc: mingo@elte.hu; hpa@zytor.com; tglx@linutronix.de; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH RFC] [x86] Optimize copy-page by reducing impact
> from HW prefetch
> 
> ling.ma@intel.com writes:
> > impact(DCU prefetcher), and simplify original code.
> > The performance is improved about 15% on core2, 36% on snb
> respectively.
> > (We use our micro-benchmark, and will do further test according to
> your requirment)
> 
> This doesn't make a lot of sense because neither Core-2 nor SNB use the
> code path you patched. They all use the rep ; movs path
> 
> -Andi
> 
> --
> ak@linux.intel.com -- Speaking for myself only
