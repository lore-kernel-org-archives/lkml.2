Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab1I0SgV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 14:36:21 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53387 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906Ab1I0SgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 14:36:17 -0400
MIME-Version: 1.0
In-Reply-To: <CAK3HsqtdgqWB36NCxz0xZxTrfp2-o8b7MYncn_P61eUv2xkAkw@mail.gmail.com>
References: <CANLaLhaEnyPchqOPp65Y0hvotM30E5daX=XNG=fAAmf1dchxCA@mail.gmail.com>
	<20110926111522.2a053ceb@lxorguk.ukuu.org.uk>
	<CAK3HsqvkpEiDWcCP_+eO0va4+io7pVV-aWCzQ1=DdpPi_jxy6g@mail.gmail.com>
	<CAMM=eLdTkpV_oy7+N2QVeqmm4t0WkAJXUmGkxWcb=X8Vp81x7A@mail.gmail.com>
	<CAK3HsqtdgqWB36NCxz0xZxTrfp2-o8b7MYncn_P61eUv2xkAkw@mail.gmail.com>
Date: Wed, 28 Sep 2011 00:06:16 +0530
Message-ID: <CANLaLhbiLC-+azrdmf3_uPYS1zR3x-Yk9tA2b0U6_z72YSjQYQ@mail.gmail.com>
Subject: Re: Detection of Advanced Format drives
From: Arun <engineerarun@gmail.com>
To: Joshua Scoggins <theoretically.x64@gmail.com>
Cc: Mike Snitzer <snitzer@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike,

Regarding "Linux does, and will bubble this additional information up
the stack."...

Should I suppose that it is an already available piece of information
to the userland? Or do I need to modify the hdparm/fdisk code to get
this piece of info?

Once again, if this is not the place to ask about
userland/hdpark/fdisk etc. please redirect to the correct location.


Regards,

Arun




On Tue, Sep 27, 2011 at 23:29, Joshua Scoggins
<theoretically.x64@gmail.com> wrote:
> Didn't know about the physical_block_size field. My AV-25 reports the
> physical_block_size as 4096 and the logical block size as 512.
>
> Thanks for the heads up and sorry about the misinformation. Not my
> intention to spread FUD like that
>
> On Mon, Sep 26, 2011 at 1:09 PM, Mike Snitzer <snitzer@gmail.com> wrote:
>> On Mon, Sep 26, 2011 at 3:48 PM, Joshua Scoggins
>> <theoretically.x64@gmail.com> wrote:
>>> Keep in mind that some AF drives will not report their actual sector
>>> sizes. I have this issue with the WD AV-25 series. This is to provide
>>> compatibility with older operating systems that don't support AF
>>> drives. These are called generation 1 devices. Newer drives will
>>> directly report their sector size as 4096 through the drive identify
>>> data older ones will say 512. At that point you just need to do a
>>> google search to see if it's AF or not.
>>
>> Linux should publish the discrepancy with these <disk> specific sysfs files:
>>
>> /sys/block/<disk>/queue/logical_block_size=512
>> /sys/block/<disk>/queue/physical_block_size=4096
>>
>> But are you saying you have an AF disk that doesn't publish this
>> discrepancy via the IDENTIFY DEVICE (ATA) or READ CAPACITY 16 (SCSI)
>> command?
>>
>
