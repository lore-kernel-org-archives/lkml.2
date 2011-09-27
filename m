Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459Ab1I0R7G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 13:59:06 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54115 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139Ab1I0R7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 13:59:05 -0400
MIME-Version: 1.0
In-Reply-To: <CAMM=eLdTkpV_oy7+N2QVeqmm4t0WkAJXUmGkxWcb=X8Vp81x7A@mail.gmail.com>
References: <CANLaLhaEnyPchqOPp65Y0hvotM30E5daX=XNG=fAAmf1dchxCA@mail.gmail.com>
	<20110926111522.2a053ceb@lxorguk.ukuu.org.uk>
	<CAK3HsqvkpEiDWcCP_+eO0va4+io7pVV-aWCzQ1=DdpPi_jxy6g@mail.gmail.com>
	<CAMM=eLdTkpV_oy7+N2QVeqmm4t0WkAJXUmGkxWcb=X8Vp81x7A@mail.gmail.com>
Date: Tue, 27 Sep 2011 10:59:03 -0700
Message-ID: <CAK3HsqtdgqWB36NCxz0xZxTrfp2-o8b7MYncn_P61eUv2xkAkw@mail.gmail.com>
Subject: Re: Detection of Advanced Format drives
From: Joshua Scoggins <theoretically.x64@gmail.com>
To: Mike Snitzer <snitzer@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Arun <engineerarun@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Didn't know about the physical_block_size field. My AV-25 reports the
physical_block_size as 4096 and the logical block size as 512.

Thanks for the heads up and sorry about the misinformation. Not my
intention to spread FUD like that

On Mon, Sep 26, 2011 at 1:09 PM, Mike Snitzer <snitzer@gmail.com> wrote:
> On Mon, Sep 26, 2011 at 3:48 PM, Joshua Scoggins
> <theoretically.x64@gmail.com> wrote:
>> Keep in mind that some AF drives will not report their actual sector
>> sizes. I have this issue with the WD AV-25 series. This is to provide
>> compatibility with older operating systems that don't support AF
>> drives. These are called generation 1 devices. Newer drives will
>> directly report their sector size as 4096 through the drive identify
>> data older ones will say 512. At that point you just need to do a
>> google search to see if it's AF or not.
>
> Linux should publish the discrepancy with these <disk> specific sysfs files:
>
> /sys/block/<disk>/queue/logical_block_size=512
> /sys/block/<disk>/queue/physical_block_size=4096
>
> But are you saying you have an AF disk that doesn't publish this
> discrepancy via the IDENTIFY DEVICE (ATA) or READ CAPACITY 16 (SCSI)
> command?
>
