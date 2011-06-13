Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328Ab1FMX24 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 19:28:56 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:1435 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755192Ab1FMX2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 19:28:52 -0400
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
From: "Jian Peng" <jipeng@broadcom.com>
To: "Joe Perches" <joe@perches.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jian Peng" <jipeng@broadcom.com>
Date: Mon, 13 Jun 2011 16:28:36 -0700
Subject: RE: two false alarms from checkpatch.pl
Thread-Topic: two false alarms from checkpatch.pl
Thread-Index: AcwqIP/zsKjd0HgXSPqx0GSH8InpFwAADaOg
Message-ID: <E18F441196CA634DB8E1F1C56A50A874572DE7E973@IRVEXCHCCR01.corp.ad.broadcom.com>
References: <E18F441196CA634DB8E1F1C56A50A874572DE7E95F@IRVEXCHCCR01.corp.ad.broadcom.com>
 <1308007436.26699.57.camel@Joe-Laptop>
In-Reply-To: <1308007436.26699.57.camel@Joe-Laptop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 61E841914NS20213077-01-01
Content-Type: text/plain;
 charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p5DNTKOk011498

Hi, Joe,

I can ignore both. On the other hand, 

while (1); 

is a style that was used universally by C programmers. Could you rethink about take this as exception in checkpatch.pl?

Thanks,
Jian

-----Original Message-----
From: Joe Perches [mailto:joe@perches.com] 
Sent: Monday, June 13, 2011 4:24 PM
To: Jian Peng
Cc: linux-kernel@vger.kernel.org
Subject: Re: two false alarms from checkpatch.pl

On Mon, 2011-06-13 at 16:18 -0700, Jian Peng wrote:
> After running "./scripts/checkpatch.pl -F arch/mips/kernel/syscall.c", I got some errors reported on valid lines
> 
> ERROR: space prohibited before open square bracket '['
> #451: FILE: mips/kernel/syscall.c:451:
> +		: [addr] "r" (addr),
> 
> This line is valid, and if I remove the space in between, it will report a different error
> 
> ERROR: spaces required around that ':' (ctx:ExV)
> #448: FILE: mips/kernel/syscall.c:448:
> +		:[old] "=&r" (old),
>  		^
> In another case, it reported

Known defect.  checkpatch doesn't correctly parse asm.
checkpatch output isn't dicta.
You should just ignore it.

> ERROR: trailing statements should be on next line
> #515: FILE: mips/kernel/syscall.c:515:
> +	while (1);
> 
> This is also valid line.

That's really not a kernel style conformant line.

It really should be written as something like:

	while (1) {
		;		/* Never exit */
	}


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
