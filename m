Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025Ab2DNWtY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 18:49:24 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:38413 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab2DNWtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 18:49:22 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyq7fp2nDGJBT+9oPTBU+uCWpp_2JBfGB3HxBSwA=5TBw@mail.gmail.com>
References: <CA+55aFxToKG2gMqHnUgjkGTr--X4FK9yzX7n0yc9xKuUGGRKmA@mail.gmail.com>
 <CA+55aFyq7fp2nDGJBT+9oPTBU+uCWpp_2JBfGB3HxBSwA=5TBw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 14 Apr 2012 15:49:01 -0700
X-Google-Sender-Auth: opvYpwuEKh-BweTEjG7ixpQ1Hqc
Message-ID: <CA+55aFyH-LCcDZmLhhctT2mz447aLMRShU-BOk7QnzAGGMzySA@mail.gmail.com>
Subject: Re: USB storage SCSI EH oops
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <JBottomley@parallels.com>,
        Jens Axboe <jaxboe@fusionio.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2012 at 3:29 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Confirmed.
>
> I tested twice: with that patch, the oops is repeatable, and happens
> something like 30 seconds after plugging in the USB thing into the
> monitor.
>
> With that patch reverted, the thing still doesn't *work*, but I don't
> get the oops. Instead, I get the appended noise in my dmesg..

.. and the reason that card reader has trouble seems to be that it's
just too damn old, and doesn't understand SD-HC cards. It works fine
with old SD cards.

So the reader is fine (well, apart from being too old), USB-storage is
fine, but the SCSI error handler is broken.

Even with that commit reverted, once the SCSI layer has decided to
off-line the device, you can't get it back, even if you remove the
media and insert a non-HC SD card. You have to unplug and re-plug the
reader. That seems to be a slight misfeature of SCSI error handling,
but compared to oopsing, it's minor.

                       Linus
