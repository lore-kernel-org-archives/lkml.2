Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758837Ab0HLGxB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 02:53:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:25164 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858Ab0HLGw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 02:52:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,356,1278313200"; 
   d="scan'208";a="646731186"
From: "Ma, Ling" <ling.ma@intel.com>
To: Namhyung Kim <namhyung@gmail.com>
CC: "hpa@zytor.com" <hpa@zytor.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>
Date: Thu, 12 Aug 2010 14:52:38 +0800
Subject: RE: [PATCH V2] [X86] Fix potential issue on memmove
Thread-Topic: [PATCH V2] [X86] Fix potential issue on memmove
Thread-Index: Acs56msbw7iHwCLaQX2KQXVuk1z1JAAAHqMA
Message-ID: <C10D3FB0CD45994C8A51FEC1227CE22F0E483AD918@shsmsx502.ccr.corp.intel.com>
References: <1281595715.1631.5.camel@leonhard>
In-Reply-To: <1281595715.1631.5.camel@leonhard>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o7C6rAo4008959

Thanks, I will fix it in next version.

> -----Original Message-----
> From: Namhyung Kim [mailto:namhyung@gmail.com]
> Sent: Thursday, August 12, 2010 2:49 PM
> To: Ma, Ling
> Cc: hpa@zytor.com; tglx@linutronix.de; linux-kernel@vger.kernel.org;
> mingo@elte.hu
> Subject: Re: [PATCH V2] [X86] Fix potential issue on memmove
> 
> > --- a/arch/x86/lib/memcpy_32.c
> > +++ b/arch/x86/lib/memcpy_32.c
> > @@ -25,19 +25,35 @@ void *memmove(void *dest, const void *src, size_t
> n)
> >	int d0, d1, d2;
> >
> > 	if (dest < src) {
> > -		memcpy(dest, src, n);
> > +		if ((dest + n) < src)
> > +			 return memcpy(dest, src, n);
> > +		else
> > +			__asm__ __volatile__(
> > +				"rep\n\t"
> > +				"movsb\n\t"
> > +				: "=&c" (d0), "=&S" (d1), "=&D" (d2)
> > +				:"0" (n),
> > +				 "1" (src),
> > +				 "2" (dest)
> > +				:"memory");
> > +
> > 	} else {
> > -		__asm__ __volatile__(
> > -			"std\n\t"
> > -			"rep\n\t"
> > -			"movsb\n\t"
> > -			"cld"
> > -			: "=&c" (d0), "=&S" (d1), "=&D" (d2)
> > -			:"0" (n),
> > -			 "1" (n-1+src),
> > -			 "2" (n-1+dest)
> > -			:"memory");
> > +		if((src + count) < dest)
> > +			return memcpy(dest, src, count);
> 
> 'count' should be 'n'.
> 
> --
> Regards,
> Namhyung Kim
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
