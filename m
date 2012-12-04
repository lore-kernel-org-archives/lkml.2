Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771Ab2LDVDY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 16:03:24 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:36969 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757Ab2LDVDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 16:03:22 -0500
From: "Andrianov, Vitaly" <vitalya@ti.com>
To: Michal Nazarewicz <mina86@mina86.com>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
CC: "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-keystone@list.ti.com - Linux developers for Keystone family of
	devices (May contain non-TIers)" <linux-keystone@list.ti.com>,
        "Chemparathy, Cyril" <cyril@ti.com>
Subject: RE: [linux-keystone] [PATCH v2] drivers: cma: fix addressing on PAE
 machines
Thread-Topic: [linux-keystone] [PATCH v2] drivers: cma: fix addressing on
 PAE machines
Thread-Index: AQHN0W1bb/yPlKolKEKNpzP1xL0znJgIl+eAgABqkICAAB93AIAARCwA//+qlMA=
Date: Tue, 4 Dec 2012 21:03:11 +0000
Message-ID: <C279DA448D408F43B343F09155C1EE9B0C228FC7@DFLE09.ent.ti.com>
References: <1354549570-21445-1-git-send-email-vitalya@ti.com>
 <50BD9C45.7070501@ti.com> <xa1tsj7m3qza.fsf@mina86.com>
 <50BE100E.1060007@ti.com> <xa1tsj7l3agx.fsf@mina86.com>
In-Reply-To: <xa1tsj7l3agx.fsf@mina86.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.170.170.90]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qB4L3Sf9011124



> -----Original Message-----
> From: Michal Nazarewicz [mailto:mpn@google.com] On Behalf Of Michal
> Nazarewicz
> Sent: Tuesday, December 04, 2012 2:05 PM
> To: Andrianov, Vitaly; Shilimkar, Santosh
> Cc: m.szyprowski@samsung.com; kyungmin.park@samsung.com; arnd@arndb.de;
> linux-kernel@vger.kernel.org; linux-keystone@list.ti.com - Linux
> developers for Keystone family of devices (May contain non-TIers);
> Chemparathy, Cyril
> Subject: Re: [linux-keystone] [PATCH v2] drivers: cma: fix addressing
> on PAE machines
> 
> > On Tuesday 04 December 2012 06:37 PM, Michal Nazarewicz wrote:
> >> They are all related to the very same issue, and what the whole
> patch
> >> does is change the type used to store physical addresses from
> >> unsigned long to phys_addr_t.  This is really a single change.
> 
> On Tue, Dec 04 2012, Santosh Shilimkar wrote:
> > Thanks for clarification. 64 bit alignment fix and the allocation
> > range checks can be two separate fixes and that is exactly what
> change
> > log describes.  You have a last say though :-) No problem if you want
> > to commit the patch as is.
> 
> I don't have strong feelings on this one, but I feel like it's really a
> single change which manifests itself in a few ways.  If this is
> confusing, maybe commit message could be improved, to something like:
> 
> ------------- >8 ------------------------------------------------------
> -
> drivers: cma: represent physicall addresses as phys_addr_t
> 
> This commit changes the CMA early initialisation code to use
> phys_addr_t for representing physical addresses instead of unsigned
> long.
> 
> Without this change, among other things, dma_declare_contiguous()
> simply discards any memory regions whose address is not represtible as
> unsigned long.
> 
> This is a problem on 32-bit PAE machines where unsigned long is 32-bit
> but physical address space is larger.
> ------------- 8< ------------------------------------------------------
> -
> 
> Vitaly, if you could resend with that description, it would be awesome,
> and sorry for so much trouble in what appears to be a trivial patch. :P
> 

Sure, I'll do that.

> --
> Best regards,                                         _     _
> .o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
> ..o | Computer Science,  MichaÅ‚ â€œmina86â€ Nazarewicz    (o o)
> ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--

Regards,
Vitaly

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
