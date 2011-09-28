Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747Ab1I1BYA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 21:24:00 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59826 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab1I1BX7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 21:23:59 -0400
MIME-Version: 1.0
In-Reply-To: <yq1pqilbqyu.fsf@sermon.lab.mkp.net>
References: <CANLaLhaEnyPchqOPp65Y0hvotM30E5daX=XNG=fAAmf1dchxCA@mail.gmail.com>
	<20110926111522.2a053ceb@lxorguk.ukuu.org.uk>
	<CAK3HsqvkpEiDWcCP_+eO0va4+io7pVV-aWCzQ1=DdpPi_jxy6g@mail.gmail.com>
	<CAMM=eLdTkpV_oy7+N2QVeqmm4t0WkAJXUmGkxWcb=X8Vp81x7A@mail.gmail.com>
	<CAK3HsqtdgqWB36NCxz0xZxTrfp2-o8b7MYncn_P61eUv2xkAkw@mail.gmail.com>
	<CANLaLhbiLC-+azrdmf3_uPYS1zR3x-Yk9tA2b0U6_z72YSjQYQ@mail.gmail.com>
	<yq11uv1dd6h.fsf@sermon.lab.mkp.net>
	<CAK2H+eeJGjMVCTAf=UDmozDK+MJUCM-HfuzuiBvuqZwSeiQzNw@mail.gmail.com>
	<CANLaLhZZdw9Wedc39VoEvpK1Xw-EXTFPD9JXsu1nJd3s8sTb2Q@mail.gmail.com>
	<yq1pqilbqyu.fsf@sermon.lab.mkp.net>
Date: Wed, 28 Sep 2011 10:23:56 +0900
Message-ID: <CAKYAXd9KwRGs3+hLxisWv=+X7fupMF0txUjGx4N9Tryn12OpaA@mail.gmail.com>
Subject: Re: Detection of Advanced Format drives
From: NamJae Jeon <linkinjeon@gmail.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Arun <engineerarun@gmail.com>, Mark Knecht <markknecht@gmail.com>,
        Joshua Scoggins <theoretically.x64@gmail.com>,
        Mike Snitzer <snitzer@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/28 Martin K. Petersen <martin.petersen@oracle.com>:
>>>>>> "Arun" == Arun  <engineerarun@gmail.com> writes:
>
> Arun> A quick check of hdparm tells me that it is using the SG_IO ioctl
> Arun> for the ATA_OP_PIDENTIFY command. Maybe I have some hopes of
> Arun> having a correct result with the BLKPBSZGET ioctl. Will check that
> Arun> out.
>
> hdparm and the kernel are looking the same place for the physical block
> size. There should be no discrepancy between what hdparm can see and
> what's reported in physical_block_size by the kernel. The BLKPBSZGET
> returns the same topology parameter as sysfs' physical_block_size.
>
> --
> Martin K. Petersen      Oracle Linux Engineering
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
plz remember, There are native 4k and 512B emulate.
In case of 512B emulate, you can see logical block size is 512Byte and
physical block size is 4KB.
Although you can access 512Byte, It should be access per 4KB in order
to prevent the loss of performance by RMW penalty.
