Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757635Ab1DHQwO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 12:52:14 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:42511 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757203Ab1DHQwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 12:52:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=CSiOfj417zxCIkdtlRL0am2VCHbSYXB9Jh+Fkui9ChR0o6DyxSNWjMcrGa4pxuhL7D
         NQREcColUoKaWEhKqCLgo4DRcoePb4f4VDBKQq0msVvChbbRK0cZg2PJM+CoY65vcqmi
         PvfAhA+4i5sDzWg+aubXfKYBRhCcVgdcSFDRk=
Date: Fri, 8 Apr 2011 09:52:07 -0700
From: Tejun Heo <tj@kernel.org>
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: Amit Shah <amit.shah@redhat.com>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        linux-scsi@vger.kernel.org, Markus Armbruster <armbru@redhat.com>
Subject: Re: [PATCH] sr: Ensure disk is revalidated when media changes
Message-ID: <20110408165207.GD3871@mtj.dyndns.org>
References: <8d830b21c0b944d26f29dc1e0c42c0bef8d448c2.1301595169.git.amit.shah@redhat.com>
 <20110401154327.GA6593@mtj.dyndns.org>
 <20110405065129.GC2872@amit-x200.redhat.com>
 <20110406100620.GA4142@mtj.dyndns.org>
 <BANLkTinpRJHr+293kPzS1=hCWRPamOOGfw@mail.gmail.com>
 <20110408162041.GB3871@mtj.dyndns.org>
 <BANLkTimYBDvcUO9Z2wdk4VFk88NpGJiZJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTimYBDvcUO9Z2wdk4VFk88NpGJiZJA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Apr 08, 2011 at 05:43:16PM +0100, Stefan Hajnoczi wrote:
> >> I think it would make sense to refresh the inode size on media change
> >> so that even open file descriptors see the new size and a single
> >> process cannot force a stale value for all other userspace processes
> >> on the system.
> >
> > Hmmm... I don't know.  Maybe we can but I'm not sure whether there's a
> > good reason for it.  cdrom is locked while opened after all.  Are
> > there actual problems?
> 
> Yeah, sorry I didn't explain what the use case was.  With QEMU you can
> pass through the physical CD-ROM into the virtual machine.
> 
> QEMU opens /dev/cdrom with O_NONBLOCK | O_RDONLY.  The guest can test
> if the medium is present and QEMU will do ioctl(fd,
> CDROM_DRIVE_STATUS, CDSL_CURRENT).  The guest can also lock the tray
> and eject, again using the respective ioctls.  Read operations are
> serviced by performing a read on the file descriptor in QEMU.  And
> finally the medium size is queried by QEMU using lseek(fd, 0,
> SEEK_END).
> 
> Today QEMU cannot keep /dev/cdrom open across media change because it
> will have an outdated inode size returned from lseek(fd, 0, SEEK_END).
>  But if the cdrom driver (or sr) refresh the inode size on media
> change then there is no need to work around this from userspace.

Hmmm... ISTR there was some discussion about changing inode size on
the fly quite a while ago.  I didn't follow the discussion but it
seemed to have rather nasty/delicate implications.

Jens, any ideas?

Thanks.

-- 
tejun
