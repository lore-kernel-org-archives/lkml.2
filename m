Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088Ab2DVOYk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 10:24:40 -0400
Received: from fallback3.mail.ru ([94.100.176.58]:45616 "EHLO
	fallback3.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504Ab2DVOYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 10:24:39 -0400
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?QXJuZCBCZXJnbWFubg==?= <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        =?UTF-8?B?UnVzc2VsbCBLaW5nIC0gQVJNIExpbnV4?= 
	<linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: =?UTF-8?B?UmVbMl06IFtQQVRDSCAwMi8xN10gQVJNIGNscHM3MTF4OiBBZGRlZCBDaXJy?=
 =?UTF-8?B?dXMgTG9naWMgRVA3MzEyIENQVSB2YXJpYW50?=
Mime-Version: 1.0
X-Mailer: mPOP Web-Mail 2.19
X-Originating-IP: [188.134.41.72]
Date: Sun, 22 Apr 2012 18:24:05 +0400
References: <1334999490-27177-1-git-send-email-shc_work@mail.ru> <20120421122044.GF24211@n2100.arm.linux.org.uk> <201204221358.29315.arnd@arndb.de>
In-Reply-To: <201204221358.29315.arnd@arndb.de>
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 
Content-Type: text/plain; charset=utf-8
Message-Id: <E1SLxht-0000II-Od.shc_work-mail-ru@f23.mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q3MEOoA4015557




Sun, 22 Apr 2012 13:58:28 +0000 Ğ¾Ñ‚ Arnd Bergmann <arnd@arndb.de>:
> On Saturday 21 April 2012, Russell King - ARM Linux wrote:
> > The headers still have to end up being in an accessible place, and having
> > drivers include the minimum required is a good idea.  Merely moving them
> > into include/mach and updating the include statements as far as I'd go.
> > (and I've never liked the idea of mach/hardware.h being an "include the
> > world for this platform" header file.)
> 
> Digging a bit deeper into clps711x, I found that with Alexander's patch
> series applied, there is nothing that actually includes the three
> asm/hardware/ep7*.h files. I wonder about the motivation behind providing
> them. Any reason we can't just remove those three files altogher?
> 
> Note that if we were to actually start using those files, this section
> of mach/hardware.h would be broken:
> 
> #if defined (CONFIG_SOC_EP7211)
> #include <asm/hardware/ep7211.h>
> #elif defined (CONFIG_SOC_EP7212)
> #include <asm/hardware/ep7212.h>
> #elif defined (CONFIG_SOC_EP7213)
> #include <asm/hardware/ep7312.h>
> #endif
> 
> Because we can have more than one of these socs enabled in the
> same configuration and enabling CONFIG_SOC_EP7211 would make the
> other two headers invisible.
We can define the ÑƒĞ·7312 registers in a single clps7111.h header and just always
keep in mind that additional registers can be used only with the corresponding processor.
In any case, additional registers are used in the code for a particular board only.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
