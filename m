Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916Ab1C3GGv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 02:06:51 -0400
Received: from mx2.parallels.com ([64.131.90.16]:60605 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812Ab1C3GGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 02:06:50 -0400
Message-ID: <4D92C874.7040104@parallels.com>
Date: Wed, 30 Mar 2011 01:06:44 -0500
From: Rob Landley <rlandley@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Pete Clements <clem@clem.clem-digital.net>
CC: Jens Axboe <jaxboe@fusionio.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: Commit 7eaceaccab5f40 causing boot hang.
References: <201103291551.p2TFpDqZ001692@clem.clem-digital.net>
In-Reply-To: <201103291551.p2TFpDqZ001692@clem.clem-digital.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2011 10:51 AM, Pete Clements wrote:
> Quoting Jens Axboe
>   > 
>   > On 2011-03-29 16:13, Rob Landley wrote:
>   > > On 03/29/2011 08:59 AM, Jens Axboe wrote:
>   > >> On 2011-03-29 10:52, Rob Landley wrote:
>   > >>> I'm booting all this under kvm or qemu, by the way:
>   > >>>
>   > >>> qemu-system-x86_64 -m 1024 -kernel arch/x86/boot/bzImage \
>   > >>>   -hda ~/sid.ext3 -append "root=/dev/hda rw"
>   > >>>
>   > >>> Sometimes with init=/bin/bash in that last quoted bit.  The root
>   > >>> filesystem's debian sid but that's probably not relevant because it
>   > >>> worked fine with .38.
>   > >>
>   > >> Does this help?
>   > >>
>   > >> diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
>   > >> index 0e406d73..ca27d30 100644
>   > >> --- a/drivers/ide/ide-io.c
>   > >> +++ b/drivers/ide/ide-io.c
>   > >> @@ -570,8 +570,7 @@ void ide_requeue_and_plug(ide_drive_t *drive, struct request *rq)
>   > >>  	spin_unlock_irqrestore(q->queue_lock, flags);
>   > >>  
>   > >>  	/* Use 3ms as that was the old plug delay */
>   > >> -	if (rq)
>   > >> -		blk_delay_queue(q, 3);
>   > >> +	blk_delay_queue(q, 3);
>   > >>  }
>   > >>  
>   > >>  static int drive_is_ready(ide_drive_t *drive)
>   > >>
>   > > 
>   > > Nope, still hung the same way.
>   > 
>   > Funky. I'll try and reproduce this tonight.
>   > 
>   > -- 
>   > Jens Axboe
>   > 
> 
> I have had a similiar problem (reported earlier) unable to boot.
> With git15-18 hung with IDE drives (hda), git19-21 moved the hang down to
> the IDE CDROM (hdc). Applied the above patch and now booted into git21 without
> any hang and all appears ok.

It may have made it better for me, it's hard to tell.

I did a fresh pull, re-applied the patch, and tried again with
init=/bin/sh and it booted to the shell prompt... which then hung when I
did "ls -l /".

If I let it boot normally, init announces itself, gives a spurious
warning about a fstab field (which it's been doing for a while, my fault
but harmless), then hangs.

> This is i386, UP.

I'm doing x86-64 SMP.

Rob
