Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423Ab1CRUL5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 16:11:57 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:63050 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756739Ab1CRULv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 16:11:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 2.6.38: XFS/USB/HW issue, or failing USB stick?
Date: Fri, 18 Mar 2011 21:11:43 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc8+; KDE/4.5.1; x86_64; ; )
Cc: Tim Soderstrom <tim@moocowproductions.org>, linux-usb@vger.kernel.org,
        xfs@oss.sgi.com, linux-kernel@vger.kernel.org,
        Alan Piszcz <ap@solarrain.com>, flashbench-results@lists.linaro.org
References: <alpine.DEB.2.02.1103181104020.30018@p34.internal.lan> <201103182033.02793.arnd@arndb.de> <alpine.DEB.2.02.1103181547590.21715@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.02.1103181547590.21715@p34.internal.lan>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103182111.43126.arnd@arndb.de>
X-Provags-ID: V02:K0:Mxs0EjIXfDCelKAcvqw5aNukWlf47IqyWxV9UGAaIgj
 HsRTKNtK6jTs1tJeV6O/rnm06Tks+fz4QqJwzRc2wWVe9riiXr
 jNL0Xie3Oda6CVefvpzUVuiwlbAEYgWEhf4QhCl+KMzZl2vdVv
 /apiRIO5NqaaZwSeCpzF6fFCCx8hgUoD2nZO2//3tkwVmQlYtx
 b9FCs4H+Fm8llto/nD2Fw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 March 2011 20:51:47 Justin Piszcz wrote:
> Disk /dev/sda: 8220 MB, 8220835840 bytes
> 154 heads, 56 sectors/track, 1861 cylinders, total 16056320 sectors
> Units = sectors of 1 * 512 = 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0x99df019d
> 
>     Device Boot      Start         End      Blocks   Id  System
> /dev/sda1            2048    16056319     8027136   83  Linux

Ok, so it has the normal 1 MB alignment. That is not too
bad then, no immediate reason to reformat, because ext2
doesn't understand the concept of erase blocks.

If the partition was completely misaligned (old fdisk would
start the first partition at sector 63 instead of 2048),
that would be a much more significant problem.

> >>> Also, what is the output of 'lsusb' for this stick? I'd like to add the
> >>> data to https://wiki.linaro.org/WorkingGroups/KernelConsolidation/Projects/FlashCardSurvey
> >> Sure,
> >> Bus 001 Device 002: ID 0325:ac02 OCZ Technology Inc ATV Turbo / Rally2 Dual Channel USB 2.0 Flash Drive
> >>
> >
> > Added now, thanks!
> >
> > Do you also have the product name for this?
> 10007937 OCZ OCZUSBR2TDC-8GB 8GB Rally2 Turbo USB 2.0 Flash Drive Retail
> Was $116.99 on 01-05-2009.
> 
> Was purported (at the time) to be one of the fastest USB sticks available,
> according to benchmarks.
> 
Ok, thanks for the detailed information.

	Arnd
