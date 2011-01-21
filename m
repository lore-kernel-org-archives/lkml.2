Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335Ab1AUQG5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 11:06:57 -0500
Received: from mga01.intel.com ([192.55.52.88]:30150 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754276Ab1AUQG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 11:06:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,358,1291622400"; 
   d="scan'208";a="649723717"
From: "Anvin, H Peter" <h.peter.anvin@intel.com>
To: "Lu, Hongjiu" <hongjiu.lu@intel.com>, "Li, Shaohua" <shaohua.li@intel.com>
CC: "'mingo@elte.hu'" <mingo@elte.hu>,
        "'markus@trippelsdorf.de'" <markus@trippelsdorf.de>,
        "'torvalds@linux-foundation.org'" <torvalds@linux-foundation.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'sam@ravnborg.org'" <sam@ravnborg.org>
Date: Fri, 21 Jan 2011 08:06:54 -0800
Subject: RE: Linux 2.6.38-rc1 doesn't boot
Thread-Topic: Linux 2.6.38-rc1 doesn't boot
Thread-Index: Acu5f92bq00plkE7Qwuwsg1b6rUE3gAATPwQAAEJx+k=
Message-ID: <ADDEBCD9C145E542A8688C29F1FBDCB9C86B5688@orsmsx502.amr.corp.intel.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p0LG7P85011958

That is surprisingly painful, which is why the high frequency of binutils bugs is a major headache to us in the kernel world.  Either way the  current code is just hacky.

-- 
Sent with Good (www.good.com)


 -----Original Message-----
From: 	Lu, Hongjiu
Sent:	Friday, January 21, 2011 07:37 AM Pacific Standard Time
To:	Anvin, H Peter; Li, Shaohua
Cc:	Ingo Molnar; Markus Trippelsdorf; Linus Torvalds; Linux Kernel Mailing List; Sam Ravnborg
Subject:	RE: Linux 2.6.38-rc1 doesn't boot

Or we can just ban those broken linker versions.

H.J.


> -----Original Message-----
> From: Anvin, H Peter
> Sent: Friday, January 21, 2011 7:29 AM
> To: Li, Shaohua
> Cc: Ingo Molnar; Markus Trippelsdorf; Lu, Hongjiu; Linus Torvalds;
> Linux Kernel Mailing List; Sam Ravnborg
> Subject: Re: Linux 2.6.38-rc1 doesn't boot
> 
> On 01/20/2011 11:18 PM, Li, Shaohua wrote:
> >  		*(.jiffies)
> >  	}
> >  	jiffies = VVIRT(.jiffies);
> > +	jiffies_64 = jiffies;
> >
> 
> OK, this is just messed up.  If we need jiffies in a special section
> then we should declare it as such (see __jiffy_data), but it's not
> clear
> to me why we would.  This seems like hack upon hack.
> 
> However, I suspect we may want to put jiffies into a .S file, and that
> .S file needs to take into account architectures which need underscore
> prefixes (which really sucks to have in ELF and is a major fail on
> those
> ABI designers...)
> 
> 	-hpa
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
