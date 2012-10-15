Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887Ab2JOFA6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 01:00:58 -0400
Received: from mga14.intel.com ([143.182.124.37]:38290 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405Ab2JOFA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 01:00:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,586,1344236400"; 
   d="scan'208";a="204444620"
From: "Ma, Ling" <ling.ma@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: Konrad Rzeszutek Wilk <konrad@kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iant@google.com" <iant@google.com>,
        George Spelvin <linux@horizon.com>
Subject: RE: [PATCH RFC 2/2] [x86] Optimize copy_page by re-arranging
 instruction sequence and saving register
Thread-Topic: [PATCH RFC 2/2] [x86] Optimize copy_page by re-arranging
 instruction sequence and saving register
Thread-Index: AQHNp3KHe7EK2OTz7EWBVGWon0YSZpezpk8AgAFdKsD//6o9gIAAnmeAgAAm14CAAq2wgIABs1Pg
Date: Mon, 15 Oct 2012 05:00:53 +0000
Message-ID: <B2310DA9850C8743AA7AA0055500E90F0FD70D8B@SHSMSX102.ccr.corp.intel.com>
References: <1349958548-1868-1-git-send-email-ling.ma@intel.com>
 <20121011143527.GA2408@localhost.localdomain>
 <B2310DA9850C8743AA7AA0055500E90F0FD709F9@SHSMSX102.ccr.corp.intel.com>
 <20121012061813.GC9881@liondog.tnic>
 <B2310DA9850C8743AA7AA0055500E90F0FD70AC5@SHSMSX102.ccr.corp.intel.com>
 <20121012180411.GA26245@liondog.tnic> <20121014105821.GB2165@liondog.tnic>
In-Reply-To: <20121014105821.GB2165@liondog.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9F516Qv023396

Thanks Boris!
So the patch is helpful and no impact for other/older machines,
I will re-send new version according to comments.
Any further comments are appreciated!

Regards
Ling

> -----Original Message-----
> From: Borislav Petkov [mailto:bp@alien8.de]
> Sent: Sunday, October 14, 2012 6:58 PM
> To: Ma, Ling
> Cc: Konrad Rzeszutek Wilk; mingo@elte.hu; hpa@zytor.com;
> tglx@linutronix.de; linux-kernel@vger.kernel.org; iant@google.com;
> George Spelvin
> Subject: Re: [PATCH RFC 2/2] [x86] Optimize copy_page by re-arranging
> instruction sequence and saving register
> 
> On Fri, Oct 12, 2012 at 08:04:11PM +0200, Borislav Petkov wrote:
> > Right, so benchmark shows around 20% speedup on Bulldozer but this is
> > a microbenchmark and before pursue this further, we need to verify
> > whether this brings any palpable speedup with a real benchmark, I
> > don't know, kernbench, netbench, whatever. Even something as boring
> as
> > kernel build. And probably check for perf regressions on the rest of
> > the uarches.
> 
> Ok, so to summarize, on AMD we're using REP MOVSQ which is even faster
> than the unrolled version. I've added the REP MOVSQ version to the
> Âµbenchmark. It nicely validates that we're correctly setting
> X86_FEATURE_REP_GOOD on everything >= F10h and some K8s.
> 
> So, to answer Konrad's question: those patches don't concern AMD
> machines.
> 
> Thanks.
> 
> --
> Regards/Gruss,
>     Boris.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
