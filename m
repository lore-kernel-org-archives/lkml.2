Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580Ab1C2PwJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 11:52:09 -0400
Received: from clem.clem-digital.net ([68.16.168.10]:43466 "EHLO
	clem.clem-digital.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab1C2PwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 11:52:07 -0400
From: Pete Clements <clem@clem.clem-digital.net>
Message-Id: <201103291551.p2TFpDqZ001692@clem.clem-digital.net>
Subject: Re: Commit 7eaceaccab5f40 causing boot hang.
To: jaxboe@fusionio.com (Jens Axboe)
Date: Tue, 29 Mar 2011 11:51:13 -0400 (EDT)
Cc: rlandley@parallels.com (Rob Landley),
        linux-kernel@vger.kernel.org (linux-kernel),
        linux-ide@vger.kernel.org (linux-ide@vger.kernel.org)
In-Reply-To: <4D91E9DA.4050504@fusionio.com>
X-Mailer: ELM [version 2.5 PL7]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Jens Axboe
  > 
  > On 2011-03-29 16:13, Rob Landley wrote:
  > > On 03/29/2011 08:59 AM, Jens Axboe wrote:
  > >> On 2011-03-29 10:52, Rob Landley wrote:
  > >>> I'm booting all this under kvm or qemu, by the way:
  > >>>
  > >>> qemu-system-x86_64 -m 1024 -kernel arch/x86/boot/bzImage \
  > >>>   -hda ~/sid.ext3 -append "root=/dev/hda rw"
  > >>>
  > >>> Sometimes with init=/bin/bash in that last quoted bit.  The root
  > >>> filesystem's debian sid but that's probably not relevant because it
  > >>> worked fine with .38.
  > >>
  > >> Does this help?
  > >>
  > >> diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
  > >> index 0e406d73..ca27d30 100644
  > >> --- a/drivers/ide/ide-io.c
  > >> +++ b/drivers/ide/ide-io.c
  > >> @@ -570,8 +570,7 @@ void ide_requeue_and_plug(ide_drive_t *drive, struct request *rq)
  > >>  	spin_unlock_irqrestore(q->queue_lock, flags);
  > >>  
  > >>  	/* Use 3ms as that was the old plug delay */
  > >> -	if (rq)
  > >> -		blk_delay_queue(q, 3);
  > >> +	blk_delay_queue(q, 3);
  > >>  }
  > >>  
  > >>  static int drive_is_ready(ide_drive_t *drive)
  > >>
  > > 
  > > Nope, still hung the same way.
  > 
  > Funky. I'll try and reproduce this tonight.
  > 
  > -- 
  > Jens Axboe
  > 

I have had a similiar problem (reported earlier) unable to boot.
With git15-18 hung with IDE drives (hda), git19-21 moved the hang down to
the IDE CDROM (hdc). Applied the above patch and now booted into git21 without
any hang and all appears ok.  This is i386, UP. 

--
Pete Clements
