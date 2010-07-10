Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab0GJJ6O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 05:58:14 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45049 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624Ab0GJJ6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 05:58:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=sy9gQqaPTSYC26dfIeSkFfbI7ivgXiYxMD7HxaYHoKVqk0Bi6QTGh0p2m/+9+Cxgtn
         fSB5dBBJSkjbWN+0QFsCDjvD2DWlwwHJ0uUyhwbKsUdEG8MkAeI6vzkKWR30gas8fiTY
         gxc62nSTNxZcAB9wxPLg23/kHtXkt0Nuzd5TE=
MIME-Version: 1.0
In-Reply-To: <4C326FE1.2020005@gmail.com>
References: <20100627232347.2f1dc4fd@debian>
	<20100705224627.3a158e8c@debian>
	<4C326FE1.2020005@gmail.com>
Date: Sat, 10 Jul 2010 12:58:09 +0300
Message-ID: <AANLkTinqjTdICdUoY2Qin6w14UxfOxl6dhOcZbnNhmoA@mail.gmail.com>
Subject: Re: ata: failed to IDENTIFY / SRST failed (errno = -16) problems 
	on/after booting 2.6.35-rc3
From: =?ISO-8859-1?Q?T=F6r=F6k_Edvin?= <edwintorok@gmail.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/7/6 Robert Hancock <hancockrwd@gmail.com>:
>> Also I noticed that the BIOS sometimes hanged during boot (probably
>> trying to establish a link to the CDROM too), resetting it a couple of
>> times allowed it to reach Linux, but then Linux hanged.
>> It could be a hardware failure of the CDROM that just happened to occur
>> after I installed 2.6.35-rc3, I don't know.
>
> It does sound like a hardware problem, yes, from those symptoms.

So from the 2 CDROM drives this one works:
ata9.00: ATAPI: ASUS CRW-5232AS, 1.01, max UDMA/33

If I plug in just the other CDROM drive (on same cable/power
connector, and unplug the working CDROM) then it hangs in the BIOS
"Detecting IDE drives....". Looks like faulty hardware.

If I have both CDROMs plugged in (on same data cable, order doesn't
seem to matter) then it hangs in the  BIOS for a while.
It eventually boots Linux, at which point I get those SRST failed
messages, and at some point it brings up the link to both CDROMs
(after 76 seconds for example):
ata9.00: ATAPI: ASUS CRW-5232AS, 1.0.1, max UDMA/33
ata9.01: ATAPI: SAMSUNG CD-ROM SH-152A, C503, max UDMA/33

In this case load average starts to climb (2.39 already) for a while,
I'll reply with more details in the other thread about that.

So this is not a regression, or a bug in Linux, it is just faulty
hardware and Linux retrying multiple times  when it fails.

Best regards,
--Edwin
