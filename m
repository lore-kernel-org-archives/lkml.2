Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab2A3IOC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 03:14:02 -0500
Received: from portal.weinmann.de ([62.8.140.122]:46333 "EHLO
	portal.weinmann.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642Ab2A3IOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 03:14:01 -0500
X-Greylist: delayed 970 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Jan 2012 03:14:00 EST
From: "Voss, Nikolaus" <N.Voss@weinmann.de>
To: "'dedekind1@gmail.com'" <dedekind1@gmail.com>
CC: "'Nicolas Ferre'" <nicolas.ferre@atmel.com>,
        "'linux-mtd@lists.infradead.org'" <linux-mtd@lists.infradead.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Date: Mon, 30 Jan 2012 08:57:17 +0100
Subject: RE: [PATCH] mtd: atmel_nand: fix access to 16 bit NAND devices
Thread-Topic: [PATCH] mtd: atmel_nand: fix access to 16 bit NAND devices
Thread-Index: Aczc930cBnGc3h3sTrWuQxqPVXVvogCK57qQ
Message-ID: <EF2E73589CA71846A15D0B2CDF79505D08AD3E5453@wm021.weinmann.com>
References: <201201251217.q0PCHmRe027024@gatekeeper.vosshq.de>
 <1327670996.26648.43.camel@sauron.fi.intel.com>
In-Reply-To: <1327670996.26648.43.camel@sauron.fi.intel.com>
Accept-Language: en-US, de-DE
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, de-DE
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q0U8E99n001013

Artem Bityutskiy wrote on 2012-01-27:
> On Wed, 2012-01-18 at 10:16 +0100, Nikolaus Voss wrote:
>> commit fb5427508abbd635e877fabdf55795488119c2d6 optimizes PIO
>> NAND accesses by using IO memcpy instead of IO read/write
>> repeated functions.
>> 
>> This breaks access to 16 bit NAND devices as memcpy_fromio()/toio()
>> _always_ use byte accesses (see arch/arm/kernel/io.c), so with
>> 16 bit NAND, one byte gets lost per NAND access cycle and NAND
>> address count is wrong.
>> 
>> Using memcpy() instead of the IO memcpy functions fixes this, but
>> depends on correct word alignment of the buffer and length has to
>> be a multiple of four, otherwise it might issue byte accesses and
>> possibly break 16 bit NAND access (cf arch/arm/lib/copy_template.S).
>> 
>> Memcpy variants seem to be the wrong approach here, since the
>> NAND controller doesn't make the NAND appear as truely randomly
>> accessible memory (as opposed to the DRAM controller which does
>> exactly that).
>> 
>> So, my proposal is to use 32 bit IO read/write (and let SMC
>> map it to 8 bit or 16 bit NAND accesses) and account for
>> length % 4 > 0 with two additional IO read/writes.
>> 
>> Signed-off-by: Nikolaus Voss <n.voss@weinmann.de>
> 
> Why not to revert fb5427508abbd635e877fabdf55795488119c2d6 instead, it
> is in my opinion a bit more readable?

No objections. I've tried to save the idea of
fb5427508abbd635e877fabdf55795488119c2d6 but that length % 4 > 0 stuff
uglifies it a little bit...

Niko


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
