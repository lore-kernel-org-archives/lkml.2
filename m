Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760118Ab0JZQxq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 12:53:46 -0400
Received: from p01c12o148.mxlogic.net ([208.65.145.71]:45279 "EHLO
	p01c12o148.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760082Ab0JZQxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 12:53:44 -0400
X-Greylist: delayed 540 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Oct 2010 12:53:43 EDT
X-MXL-Hash: 4cc707972531ca02-f23e3ed9ae917a997a74cd7db7cad7f395ff9aa5
X-MXL-Hash: 4cc705701fa4c8a5-7418aaa00f891ddaf0049dad8c0501fce420a05f
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: David Woodhouse <dwmw2@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 26 Oct 2010 11:43:34 -0500
Subject: RE: linux-next: build warnings after merge of the final tree (mtd
 tree related)
Thread-Topic: linux-next: build warnings after merge of the final tree (mtd
 tree related)
Thread-Index: Act0+5qHWtTcx3aXTNO97ZiBDPt1VQAMLb0g
Message-ID: <0D753D10438DA54287A00B027084269764818E2136@AUSP01VMBX24.collaborationhost.net>
References: <20101026134959.86b807d1.sfr@canb.auug.org.au>
	 <1288083108.29264.14.camel@macbook.infradead.org>
 <1288090180.29264.26.camel@macbook.infradead.org>
In-Reply-To: <1288090180.29264.26.camel@macbook.infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010073001)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [216.166.12.32]
X-AnalysisOut: [v=1.0 c=1 a=U9i-YIPZ4G0A:10 a=BLceEmwcHowA:10 a=IkcTkHD0fZ]
X-AnalysisOut: [MA:10 a=zbe46bahRtDx8aUBN1lPzQ==:17 a=JfrnYn6hAAAA:8 a=T_m]
X-AnalysisOut: [ioFW9NUn9M2MFk34A:9 a=y3carnwEiHGXGDJFJHPr55cR490A:4 a=QEX]
X-AnalysisOut: [dDO2ut3YA:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o9QGrxQQ012051

On Tuesday, October 26, 2010 3:50 AM, David Woodhouse wrote:
> On Tue, 2010-10-26 at 09:51 +0100, David Woodhouse wrote:
>> On Tue, 2010-10-26 at 13:49 +1100, Stephen Rothwell wrote:
>>> 
>>> I am not sure where these came from ... 
>> 
>> It's a config issue. You have chosen to build NOR flash support.
>> 
>> NOR flash can be wired up many ways. It could be four 8-bit chips in
>> parallel in a 32-bit bus, two 16-bit chips in a 32-bit bus, 2 8-bit
>> chips in a 16-bit bus, one 16-bit chip in a 16-bus bus, etc...
>> 
>> You have elected to support *none* of those configurations. No NOR chip
>> support can work.
>> 
>> You don't get to choose individual geometry options unless you set
>> CONFIG_MTD_ADV_OPTIONS -- by default you get a fully versatile driver
>> which can cope with anything at runtime.
>> 
>> I'll build a ppc44x_defconfig and work out what's going wrong. I'd
>> expect this kind of thing with randconfig, but not a defconfig.
>
> Fixed by reverting the offending commit:
> http://git.infradead.org/mtd-2.6.git/commitdiff/6411bf6cd

I didn't follow the logic for the MTD_MAP_BANK_WIDTH_* all the way thru.

Honestly I still don't quite get it.  If MTD_CFI_GEOMETRY is n wouldn't
all the MTD_MAP_BANK_WIDTH_* also be n?

Sorry about the trouble.

Hartleyÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
