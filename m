Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762260Ab2KAVJP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 17:09:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:14021 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759940Ab2KAVJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 17:09:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,695,1344236400"; 
   d="scan'208";a="235927039"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>, Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RE: [RFC EDAC/GHES] edac: lock module owner to avoid error report
 conflicts
Thread-Topic: [RFC EDAC/GHES] edac: lock module owner to avoid error report
 conflicts
Thread-Index: AQHNuCDOuRD+LyTnWU633Vkrr6zwkZfVUmSAgACISoD//5ZoIA==
Date: Thu, 1 Nov 2012 21:09:07 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F19D5C13C@ORSMSX108.amr.corp.intel.com>
References: <048a00fa4a888b349be5954ce9fd063a7bcf2564.1351691230.git.mchehab@redhat.com>
 <20121101110512.GA31271@liondog.tnic> <20121101094721.2a57719c@redhat.com>
 <20121101195509.GE31271@liondog.tnic>
In-Reply-To: <20121101195509.GE31271@liondog.tnic>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qA1L9IQT026886

> That is correct, unfortunately. That information is not available to
> software in all cases. Maybe APEI could be used for that DIMM location
> mapping through simple tables instead of letting it fumble the error
> handling path.

Not much hope for "simple"[1] tables.  There is also a timings issue on
system with rank sparing, memory mirroring etc.  ... you need to decode
to the DIMM at the time the error happened. If you wait until later, then
the system may have switched over to the spare rank or mirror ... and then
your decode will point at the new target, rather than the old.

-Tony

[1] Consider a 4 cpu-socket machine with 4 channels per socket and three
DIMMs per channel - so there are 48 sockets on the motherboard. Then
some lab monkey takes a box of random 1, 2, 4, 8 GB DIMMs and fills
most of the sockets. BIOS will somehow make sense out of this and interleave
where it finds matching speeds across pairs/quads of channels (though size
need not match ... if you have a 2G and 4G DIMM you may get interleaving for
the part. then non-interleaved for the "extra" 2G).
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
