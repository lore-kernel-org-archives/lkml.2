Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022Ab2DRH6Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 03:58:25 -0400
Received: from mx2.parallels.com ([64.131.90.16]:49743 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730Ab2DRH6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 03:58:23 -0400
From: James Bottomley <jbottomley@parallels.com>
To: Jens Axboe <axboe@kernel.dk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: USB storage SCSI EH oops
Thread-Topic: USB storage SCSI EH oops
Thread-Index: AQHNGoyLQYsfnt9fzkSbpcIofu9OGJabXHwAgAAFVYCABU8SgIAAAPWAgAAAbwA=
Date: Wed, 18 Apr 2012 07:58:19 +0000
Message-ID: <1334735898.4410.18.camel@dabdike>
References: <CA+55aFxToKG2gMqHnUgjkGTr--X4FK9yzX7n0yc9xKuUGGRKmA@mail.gmail.com>
	  <CA+55aFyq7fp2nDGJBT+9oPTBU+uCWpp_2JBfGB3HxBSwA=5TBw@mail.gmail.com>
	  <CA+55aFyH-LCcDZmLhhctT2mz447aLMRShU-BOk7QnzAGGMzySA@mail.gmail.com>
	 <1334735599.4410.17.camel@dabdike> <4F8E73BD.1040904@kernel.dk>
In-Reply-To: <4F8E73BD.1040904@kernel.dk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [195.214.232.10]
Content-Type: text/plain; charset="utf-8"
Content-ID: <E81817EF765E2A4CAC3E071A06060A49@sw.swsoft.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q3I7wdMF017179

On Wed, 2012-04-18 at 09:56 +0200, Jens Axboe wrote:
> On 04/18/2012 09:53 AM, James Bottomley wrote:
> > On Sat, 2012-04-14 at 15:49 -0700, Linus Torvalds wrote:
> >> On Sat, Apr 14, 2012 at 3:29 PM, Linus Torvalds
> >> <torvalds@linux-foundation.org> wrote:
> >>>
> >>> Confirmed.
> >>>
> >>> I tested twice: with that patch, the oops is repeatable, and happens
> >>> something like 30 seconds after plugging in the USB thing into the
> >>> monitor.
> >>>
> >>> With that patch reverted, the thing still doesn't *work*, but I don't
> >>> get the oops. Instead, I get the appended noise in my dmesg..
> >>
> >> .. and the reason that card reader has trouble seems to be that it's
> >> just too damn old, and doesn't understand SD-HC cards. It works fine
> >> with old SD cards.
> >>
> >> So the reader is fine (well, apart from being too old), USB-storage is
> >> fine, but the SCSI error handler is broken.
> >>
> >> Even with that commit reverted, once the SCSI layer has decided to
> >> off-line the device, you can't get it back, even if you remove the
> >> media and insert a non-HC SD card. You have to unplug and re-plug the
> >> reader. That seems to be a slight misfeature of SCSI error handling,
> >> but compared to oopsing, it's minor.
> > 
> > OK, will either queue the update or a revert.
> 
> Martins patch went into -git 4 days ago. Since Linus didn't follow up in
> rage, I was assuming the issue had been resolved with that.

Hm, OK ... I'm not sure currently the original patch is correct, but we
can sort that out as part of the normal process.

James


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
