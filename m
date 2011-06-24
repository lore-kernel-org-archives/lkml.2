Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760279Ab1FXCCg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 22:02:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:42227 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760159Ab1FXCCc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 22:02:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,417,1304319600"; 
   d="scan'208";a="19080053"
From: "Ma, Ling" <ling.ma@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>
CC: "hpa@zytor.com" <hpa@zytor.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 24 Jun 2011 10:01:28 +0800
Subject: RE: [PATCH RFC] [x86] Optimize copy-page by reducing impact from HW
 prefetch
Thread-Topic: [PATCH RFC] [x86] Optimize copy-page by reducing impact from
 HW prefetch
Thread-Index: Acwxc9zXuTo3YQvYQpKzil1gi1OinwAnn06g
Message-ID: <C10D3FB0CD45994C8A51FEC1227CE22F240ECD6FDD@shsmsx502.ccr.corp.intel.com>
References: <1308351117-32452-1-git-send-email-ling.ma@intel.com>
 <m2fwn13a3u.fsf@firstfloor.org> <20110623070448.GA25707@elte.hu>
In-Reply-To: <20110623070448.GA25707@elte.hu>
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

Sure, I separate two patches ASAP, one is for performance tuning code after some experiments,
another code style patch.

Thanks
Ling

> -----Original Message-----
> From: Ingo Molnar [mailto:mingo@elte.hu]
> Sent: Thursday, June 23, 2011 3:05 PM
> To: Andi Kleen
> Cc: Ma, Ling; hpa@zytor.com; tglx@linutronix.de; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH RFC] [x86] Optimize copy-page by reducing impact
> from HW prefetch
> 
> 
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > ling.ma@intel.com writes:
> >
> > > impact(DCU prefetcher), and simplify original code. The
> > > performance is improved about 15% on core2, 36% on snb
> > > respectively. (We use our micro-benchmark, and will do further
> > > test according to your requirment)
> >
> > This doesn't make a lot of sense because neither Core-2 nor SNB use
> > the code path you patched. They all use the rep ; movs path
> 
> Ling, mind double checking which one is the faster/better one on SNB,
> in cold-cache and hot-cache situations, copy_page or copy_page_c?
> 
> Also, while looking at this file please fix the countless pieces of
> style excrements it has before modifying it:
> 
>  - non-Linux comment style (and needless two comments - it can
>    be in one comment block):
> 
>   /* Don't use streaming store because it's better when the target
>      ends up in cache. */
> 
>   /* Could vary the prefetch distance based on SMP/UP */
> 
>  - (there's other non-standard comment blocks in this file as well)
> 
>  - The copy_page/copy_page_c naming is needlessly obfuscated, it
>    should be copy_page, copy_page_norep or so - the _c postfix has no
>    obvious meaning.
> 
>  - all #include's should be at the top
> 
>  - please standardize it on the 'instrn %x, %y' pattern that we
>    generally use in arch/x86/, not 'instrn %x,%y' pattern.
> 
> and do this cleanup patch first and the speedup on top of it, and
> keep the two in two separate patches so that the modification to the
> assembly code can be reviewed more easily.
> 
> Thanks,
> 
> 	Ingo
