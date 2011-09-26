Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189Ab1IZUKX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 16:10:23 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48853 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432Ab1IZUKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 16:10:22 -0400
MIME-Version: 1.0
In-Reply-To: <CAK3HsqvkpEiDWcCP_+eO0va4+io7pVV-aWCzQ1=DdpPi_jxy6g@mail.gmail.com>
References: <CANLaLhaEnyPchqOPp65Y0hvotM30E5daX=XNG=fAAmf1dchxCA@mail.gmail.com>
 <20110926111522.2a053ceb@lxorguk.ukuu.org.uk> <CAK3HsqvkpEiDWcCP_+eO0va4+io7pVV-aWCzQ1=DdpPi_jxy6g@mail.gmail.com>
From: Mike Snitzer <snitzer@gmail.com>
Date: Mon, 26 Sep 2011 16:09:50 -0400
Message-ID: <CAMM=eLdTkpV_oy7+N2QVeqmm4t0WkAJXUmGkxWcb=X8Vp81x7A@mail.gmail.com>
Subject: Re: Detection of Advanced Format drives
To: Joshua Scoggins <theoretically.x64@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Arun <engineerarun@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 26, 2011 at 3:48 PM, Joshua Scoggins
<theoretically.x64@gmail.com> wrote:
> Keep in mind that some AF drives will not report their actual sector
> sizes. I have this issue with the WD AV-25 series. This is to provide
> compatibility with older operating systems that don't support AF
> drives. These are called generation 1 devices. Newer drives will
> directly report their sector size as 4096 through the drive identify
> data older ones will say 512. At that point you just need to do a
> google search to see if it's AF or not.

Linux should publish the discrepancy with these <disk> specific sysfs files:

/sys/block/<disk>/queue/logical_block_size=512
/sys/block/<disk>/queue/physical_block_size=4096

But are you saying you have an AF disk that doesn't publish this
discrepancy via the IDENTIFY DEVICE (ATA) or READ CAPACITY 16 (SCSI)
command?
