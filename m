Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020Ab1GAFZc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 01:25:32 -0400
Received: from anubis.se.axis.com ([195.60.68.12]:56056 "EHLO
	anubis.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab1GAFZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 01:25:31 -0400
From: Mikael Starvik <mikael.starvik@axis.com>
To: Andreas Schwab <schwab@linux-m68k.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
CC: Christoph Hellwig <hch@infradead.org>, Randy Dunlap <rdunlap@xenotime.net>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        Jesper Nilsson <jespern@axis.com>,
        linux-cris-kernel <linux-cris-kernel@axis.com>
Date: Fri, 1 Jul 2011 07:25:27 +0200
Subject: RE: Build regressions/improvements in v3.0-rc5 (ssize_t ???)
Thread-Topic: Build regressions/improvements in v3.0-rc5 (ssize_t ???)
Thread-Index: Acw3SQpExRV5nVo/REWwVyCfm5mfSAAZjMjg
Message-ID: <4BEA3FF3CAA35E408EA55C7BE2E61D055C63F4D814@xmail3.se.axis.com>
References: <alpine.DEB.2.00.1106291011400.10665@ayla.of.borg>
	<20110629140630.5aefdda8.rdunlap@xenotime.net>
	<BANLkTin80p6gh0+Kga_92=wNEoAr9gFR2Q@mail.gmail.com>
	<20110630080119.GA20802@infradead.org>
	<BANLkTik81kgf=g+QngnaB7gNUF+xCQdSvw@mail.gmail.com>
 <m2y60jmeo3.fsf@igel.home>
In-Reply-To: <m2y60jmeo3.fsf@igel.home>
Accept-Language: sv-SE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: sv-SE
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p615PrX3032097

Also note that sizeof(long) == sizeof(int) for cris.

-----Original Message-----
From: Andreas Schwab [mailto:schwab@linux-m68k.org] 
Sent: den 30 juni 2011 19:07
To: Geert Uytterhoeven
Cc: Christoph Hellwig; Randy Dunlap; Linux Kernel Development; Mikael Starvik; Jesper Nilsson; linux-cris-kernel
Subject: Re: Build regressions/improvements in v3.0-rc5 (ssize_t ???)

Geert Uytterhoeven <geert@linux-m68k.org> writes:

> On Thu, Jun 30, 2011 at 10:01, Christoph Hellwig <hch@infradead.org> wrote:
>> On Thu, Jun 30, 2011 at 08:59:28AM +0200, Geert Uytterhoeven wrote:
>>> Nope. Also only happens on cris, which has in
>>> arch/cris/include/asm/posix_types.h:
>>>
>>> typedef long Â  Â  Â  Â  Â  Â __kernel_ssize_t;
>>>
>>> The "long" should be "int".
>>> But probably it should just include <asm-generic/posix_types.h> instead.
>>
>> Changing a user visible type won't be very nice for those using it in
>> C++ code.
>
> Are __kernel_* types exported to C++ userspace?

Currently, no exported kernel header is using __kernel_ssize_t, so it
may not be too late to change cris.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
