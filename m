Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634Ab1I0UKa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 16:10:30 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:56836 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331Ab1I0UK3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 16:10:29 -0400
MIME-Version: 1.0
In-Reply-To: <yq11uv1dd6h.fsf@sermon.lab.mkp.net>
References: <CANLaLhaEnyPchqOPp65Y0hvotM30E5daX=XNG=fAAmf1dchxCA@mail.gmail.com>
	<20110926111522.2a053ceb@lxorguk.ukuu.org.uk>
	<CAK3HsqvkpEiDWcCP_+eO0va4+io7pVV-aWCzQ1=DdpPi_jxy6g@mail.gmail.com>
	<CAMM=eLdTkpV_oy7+N2QVeqmm4t0WkAJXUmGkxWcb=X8Vp81x7A@mail.gmail.com>
	<CAK3HsqtdgqWB36NCxz0xZxTrfp2-o8b7MYncn_P61eUv2xkAkw@mail.gmail.com>
	<CANLaLhbiLC-+azrdmf3_uPYS1zR3x-Yk9tA2b0U6_z72YSjQYQ@mail.gmail.com>
	<yq11uv1dd6h.fsf@sermon.lab.mkp.net>
Date: Tue, 27 Sep 2011 13:10:28 -0700
Message-ID: <CAK2H+eeJGjMVCTAf=UDmozDK+MJUCM-HfuzuiBvuqZwSeiQzNw@mail.gmail.com>
Subject: Re: Detection of Advanced Format drives
From: Mark Knecht <markknecht@gmail.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Arun <engineerarun@gmail.com>,
        Joshua Scoggins <theoretically.x64@gmail.com>,
        Mike Snitzer <snitzer@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 11:59 AM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Arun" == Arun  <engineerarun@gmail.com> writes:
>
> Arun> Should I suppose that it is an already available piece of
> Arun> information to the userland?
>
> Yes, in the sysfs locations Mike mentioned:
>
>  /sys/block/foo/queue/physical_block_size
>
> Or you can use the BLKPBSZGET ioctl.
>
>
> Arun> Or do I need to modify the hdparm/fdisk code to get this piece of
> Arun> info?
>
> Recent hdparm versions will also report the right thing:
>
> # hdparm -I /dev/sdc | grep Sector
>        Logical  Sector size:                   512 bytes
>        Physical Sector size:                  4096 bytes
>        Logical Sector-0 offset:                512 bytes
>
> --
> Martin K. Petersen      Oracle Linux Engineering

As someone else pointed out earlier, not every drive with 4K sectors
will tell you it has 4K sectors, at least not using hdparm. This is a
WD 1TB drive circa early last year for which I've not updated
firmware. (If there is an update)

gandalf ~ # hdparm -I /dev/sda | grep Sector
        Logical/Physical Sector size:           512 bytes
gandalf ~ #

gandalf ~ # cat /sys/block/sda/queue/physical_block_size
512
gandalf ~ #

- Mark
