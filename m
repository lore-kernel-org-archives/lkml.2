Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057Ab2LPSJR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 13:09:17 -0500
Received: from mga01.intel.com ([192.55.52.88]:20149 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981Ab2LPSJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 13:09:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,294,1355126400"; 
   d="scan'208";a="265012001"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: H Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Yinghai Lu <yinghai@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: RE: [PATCH v3 04/10] x86/microcode_core_early.c: Define interfaces
 for early loading ucode
Thread-Topic: [PATCH v3 04/10] x86/microcode_core_early.c: Define interfaces
 for early loading ucode
Thread-Index: AQHN27U34IvUkXtHHU2XfDccrM1wdZgcPEoA//96QjA=
Date: Sun, 16 Dec 2012 18:09:12 +0000
Message-ID: <3E5A0FA7E9CA944F9D5414FEC6C71220470F814C@ORSMSX105.amr.corp.intel.com>
References: <1355654609-16800-1-git-send-email-fenghua.yu@intel.com>
 <1355654609-16800-5-git-send-email-fenghua.yu@intel.com>
 <20121216175722.GA14678@liondog.tnic>
In-Reply-To: <20121216175722.GA14678@liondog.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qBGI9HiZ009838

> -----Original Message-----
> From: Borislav Petkov [mailto:bp@alien8.de]
> Sent: Sunday, December 16, 2012 9:57 AM
> To: Yu, Fenghua
> Cc: H Peter Anvin; Ingo Molnar; Thomas Gleixner; Mallick, Asit K;
> Tigran Aivazian; Andreas Herrmann; Borislav Petkov; Yinghai Lu; linux-
> kernel; x86
> Subject: Re: [PATCH v3 04/10] x86/microcode_core_early.c: Define
> interfaces for early loading ucode
> 
> On Sun, Dec 16, 2012 at 02:43:23AM -0800, Fenghua Yu wrote:
> > +#define QCHAR(a, b, c, d) ((a) + ((b) << 8) + ((c) << 16) + ((d) <<
> 24))
> > +#define CPUID_INTEL1 QCHAR('G', 'e', 'n', 'u')
> > +#define CPUID_INTEL2 QCHAR('i', 'n', 'e', 'I')
> > +#define CPUID_INTEL3 QCHAR('n', 't', 'e', 'l')
> > +#define CPUID_AMD1 QCHAR('A', 'u', 't', 'h')
> > +#define CPUID_AMD2 QCHAR('e', 'n', 't', 'i')
> > +#define CPUID_AMD3 QCHAR('c', 'A', 'M', 'D')
> > +
> > +#define CPUID_IS(a, b, c) (!((ebx ^ (a))|(edx ^ (b))|(ecx ^ (c))))
> 
> What, this macro is relying on external variable names and doesn't have
> them as its own macro arguments? Why? This is really fragile and very
> much prone to errors.
> 
> What's wrong with doing:
> 
> #define CPUID_IS(a, b, c, ebx, ecx, edx) (!(((ebx) ^ (a))|((edx) ^
> (b))|((ecx) ^ (c))))
> 
> ?

Nothing wrong with taking the parameters. But CPUID_IS is only limited in this file. There is no other places to use it. I think either way is ok.

Thanks.

-Fenghua
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
