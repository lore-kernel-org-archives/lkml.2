Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397Ab0HRQuI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 12:50:08 -0400
Received: from p01c11o149.mxlogic.net ([208.65.144.72]:36173 "EHLO
	p01c11o149.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab0HRQuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 12:50:05 -0400
X-MXL-Hash: 4c6c0f3d79ad367e-bf4d1bf31a089108bc8e9d7fb956d1bcccb188e8
X-MXL-Hash: 4c6c0f285750e48d-c8037e796516318aae7614eb74036acd2401d251
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Joe Perches <joe@perches.com>, Sam Ravnborg <sam@ravnborg.org>
CC: Christoph Hellwig <hch@infradead.org>, "Ted Ts'o" <tytso@mit.edu>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "matthew@wil.cx" <matthew@wil.cx>
Date: Wed, 18 Aug 2010 11:48:37 -0500
Subject: RE: [PATCH] fs.h: introduce functions to get/set file->private_data
Thread-Topic: [PATCH] fs.h: introduce functions to get/set file->private_data
Thread-Index: Acs+dTogR4gFa36oSVijTV56rsUllgAfvbUg
Message-ID: <0D753D10438DA54287A00B0270842697643E5A1CDF@AUSP01VMBX24.collaborationhost.net>
References: <201008161137.53187.hartleys@visionengravers.com>
	 <20100816231753.GA16546@infradead.org>
	 <0D753D10438DA54287A00B0270842697643E50D82E@AUSP01VMBX24.collaborationhost.net>
	 <1282002601.6518.116.camel@Joe-Laptop> <20100817010355.GG21182@thunk.org>
	 <20100817085428.GA25330@infradead.org>
	 <1282065973.24541.106.camel@Joe-Laptop>
	 <20100817175851.GA11463@merkur.ravnborg.org>
 <1282095142.6724.11.camel@Joe-Laptop>
In-Reply-To: <1282095142.6724.11.camel@Joe-Laptop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010073001)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [216.166.12.99]
X-AnalysisOut: [v=1.0 c=1 a=Am2CfNgCDXIA:10 a=VphdPIyG4kEA:10 a=IkcTkHD0fZ]
X-AnalysisOut: [MA:10 a=MfCJKx98tC58LqYwCYfhJw==:17 a=2ep14tqfsFQMehyImlUA]
X-AnalysisOut: [:9 a=lBac3VEERl3eQJ-NzKnVXCAipFgA:4 a=QEXdDO2ut3YA:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o7IGoKI6016938

On Tuesday, August 17, 2010 6:32 PM, Joe Perches wrote:
> On Tue, 2010-08-17 at 19:58 +0200, Sam Ravnborg wrote:
>> It takes minimum effort to create and test, and if you can
>> get ack from Ted and/or Christoph there is a good chance Linus
>> would take it right before/after -rc1.
>> 
>> You obviously need to convince him that the patch has
>> seen decent build testing.
>
> private_data is the only non f_ prefixed member in
> struct file, so while there is perhaps a tiny value
> in this patch, I'm not in a hurry to push it.
>
> After a few corrections, Documentation/, comment and
> printk updates, a few macros that spatch didn't update,
> etc, the diff that converts struct file member
> private_data to f_private_data is now:
>
> $ git diff --shortstat ..da5cabf80e2433131bf0ed8993abc0f7ea618c73
>  511 files changed, 2638 insertions(+), 2639 deletions(-)
>
> Does either Ted or Christoph want to see it?
>
> Harley?  You want it?

Uh... No... ;-)

> It's still ~850BKB and probably shouldn't be posted to
> the ML as it's mostly mechanical.

I would like to see it merged just to ease grepping but if no one else
sees any benefit doing it I can live with it.

FWIW, the only reason for bringing this up in the first place was I was
trying to find all the places that have unnecessary casts when using
the private_data.  Stuff like:

	struct my_struct *my_data = (struct my_struct *)file->private_data;

Maybe it would be simpler to use spatch to just fix those?

> Compiles x86 allyesconfig, defconfig

Regards,
Hartleyÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
