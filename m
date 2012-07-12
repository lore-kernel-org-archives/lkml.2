Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030676Ab2GLPQx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 11:16:53 -0400
Received: from mail.digidescorp.com ([50.73.98.161]:8646 "EHLO
	mail.digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932679Ab2GLPQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 11:16:51 -0400
DomainKey-Signature: a=rsa-sha1; s=MDaemon; d=digidescorp.com;
	c=simple; q=dns; h=message-id:from;
	b=QQJM8bs0fRG46uduya7kwLqO3FHMKT83RujOmrz74X5aGcWpbj5d0BYrvg2m
	TlGxMo28pqudW2QnPjlRxB+usu7voLAFHYw+ve74W5DtpK8mBAtAV5h5p
	LmiuHYOUynK6XV4fi3Zt1C1zdBNAdu5OVgR+J45fB3KBBzlgFE5Q8I=;
X-Spam-Processed: mail.digidescorp.com, Thu, 12 Jul 2012 10:16:49 -0500
	(not processed: message from trusted or authenticated source)
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=15403394f6=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Message-ID: <1342106206.2156.2.camel@iscandar.digidescorp.com>
Subject: Re: mount -o loop with truncated dosdisk.img uses 100% cpu and
 can't be killed
From: "Steven J. Magnani" <steve@digidescorp.com>
To: Stevie Trujillo <stevie.trujillo@gmail.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, linux-kernel@vger.kernel.org
Date: Thu, 12 Jul 2012 10:16:46 -0500
In-Reply-To: <20120712162828.3f561315@localhost>
References: <20120712162828.3f561315@localhost>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3 (3.4.3-1.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-12 at 16:28 +0200, Stevie Trujillo wrote: 
> Hello,
> 
> I was trying to create a bootdisk to update my BIOS, and accidentially
> made a 512byte image with only the FreeDOS header in it.
> 
> ( Linux 3.4.4 )
> # mount -o loop dosdisk.img /tmp
> ^C^C^C
> It uses 100% CPU and doesn't listen to me when I do ^C, kill -9 etc. I
> think this means it's stuck in the kernel?

Here is the stack trace I get for the mount process:

[root@telezart smagnani]# cat /proc/1334/stack
[<ffffffff81077a5a>] __cond_resched+0x2a/0x40
[<ffffffff8110c4bb>] find_lock_page+0x3b/0x80
[<ffffffff8110cbaf>] find_or_create_page+0x3f/0xb0
[<ffffffff8119a692>] __getblk+0xf2/0x2a0
[<ffffffff8119a893>] __bread+0x13/0xb0
[<ffffffffa00fd1fe>] fat__get_entry+0x14e/0x220 [fat]
[<ffffffffa00fd596>] fat_get_short_entry+0x66/0xc0 [fat]
[<ffffffffa00ff765>] fat_subdirs+0x55/0x80 [fat]
[<ffffffffa0103d30>] fat_fill_super+0x810/0xa80 [fat]
[<ffffffffa00e821a>] vfat_fill_super+0x1a/0x20 [vfat]
[<ffffffff8116d61b>] mount_bdev+0x1cb/0x210
[<ffffffffa00e81f5>] vfat_mount+0x15/0x20 [vfat]
[<ffffffff8116e410>] mount_fs+0x20/0xd0
[<ffffffff81186e4f>] vfs_kern_mount+0x6f/0x100
[<ffffffff81187804>] do_kern_mount+0x54/0x110
[<ffffffff811891d6>] do_mount+0x306/0x8b0
[<ffffffff811898cd>] sys_mount+0x8d/0xe0
[<ffffffff81583629>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff

I would think this is more likely a bug in the loopback driver than the
FAT filesystem...
------------------------------------------------------------------------
Steven J. Magnani               "I claim this network for MARS!
www.digidescorp.com              Earthling, return my space modulator!"

#include <standard.disclaimer>


