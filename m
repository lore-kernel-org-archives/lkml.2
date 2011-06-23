Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759696Ab1FWQ0I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 12:26:08 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:21761
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758983Ab1FWQ0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 12:26:06 -0400
X-SpamScore: -9
X-BigFish: VPS-9(zz1432N98dKzz1202hzz8275dhz2fh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:80.242.17.33;KIP:(null);UIP:(null);IPVD:NLI;H:JKLMAIL02.ixonos.local;RD:po02.ixonos.com;EFVD:NLI
From: =?utf-8?B?UGVudHRpbMOkIE1pa2E=?= <mika.penttila@ixonos.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] x86_64: do not assume head_64.S used 4KB pages when
 !use_pse
Thread-Topic: [PATCH] x86_64: do not assume head_64.S used 4KB pages when
 !use_pse
Thread-Index: AQHMMaRwWxboH6O3MkmoW91VS58sVpTLBkGQ///WEwCAAERZ8A==
Date: Thu, 23 Jun 2011 16:25:34 +0000
Message-ID: <1A61D8EA6755AF458F06EA669A4EC8182F05B0F8@JKLMAIL02.ixonos.local>
References: <1A61D8EA6755AF458F06EA669A4EC8182F05B07E@JKLMAIL02.ixonos.local>
 <alpine.DEB.2.00.1106231354350.12963@kaball-desktop>
 <1A61D8EA6755AF458F06EA669A4EC8182F05B0C6@JKLMAIL02.ixonos.local>
 <alpine.DEB.2.00.1106231604070.12963@kaball-desktop>
In-Reply-To: <alpine.DEB.2.00.1106231604070.12963@kaball-desktop>
Accept-Language: en-US, fi-FI
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.16.31]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: ixonos.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p5NGQJ2Y028338

> From: Stefano Stabellini [mailto:stefano.stabellini@eu.citrix.com]
> Sent: 23. kesÃ¤kuuta 2011 18:20
> To: PenttilÃ¤ Mika
> Cc: Stefano Stabellini; linux-kernel@vger.kernel.org
> Subject: RE: [PATCH] x86_64: do not assume head_64.S used 4KB pages
> when !use_pse
> 
> On Thu, 23 Jun 2011, PenttilÃ¤ Mika wrote:
> > > > And arch/x86/mm/init.c also has:
> > > >
> > > > #if defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_KMEMCHECK)
> > > >         /*
> > > >          * For CONFIG_DEBUG_PAGEALLOC, identity mapping will use
> > > small pages.
> > > >          * This will simplify cpa(), which otherwise needs to
> support
> > > splitting
> > > >          * large pages into small in interrupt context, etc.
> > > >          */
> > > >         use_pse = use_gbpages = 0;
> > > > #else
> > > >         use_pse = cpu_has_pse;
> > > >         use_gbpages = direct_gbpages;
> > > > #endif
> > > >
> > > >
> > > > So big pages are also not used for DEBUG_PAGEALLOC and KMEMCHECK
> > > configs even if head_32.S did.
> > >
> > > Right, but that is not a problem because head_32.S always uses 4KB
> > > pages.
> >
> > We use large pages FOR PAE kernels on x86-32 there
> >
> 
> Do you mean we use large pages for PAE kernels on x86_32 in
> arch/x86/mm/init.c:init_memory_mapping?
> That wouldn't be a problem for this patch.
> 
> The problem I am trying to solve occurs when head_64.S doesn't allocate
> any pte pages because it is using 2MB pages, while init_memory_mapping
> wants to use 4KB pages (for example because the user set
> CONFIG_DEBUG_PAGEALLOC).
> 
> So on x86_32 is not going to be an issue because head_32.S doesn't use
> 2MB or 4MB pages as far as I can tell, even if the hardware supports
> them.
> Please correct me if I am wrong but I don't see any _PAGE_PSE in
> head_32.S.


Yes you're right head_32.S doesn't do large pages, I remembered it would..

--Mika


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
