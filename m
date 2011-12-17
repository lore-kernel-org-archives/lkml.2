Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760073Ab1LPXNd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 18:13:33 -0500
Received: from postino.bo.infn.it ([131.154.11.5]:47365 "EHLO
	postino.bo.infn.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488Ab1LPXN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 18:13:26 -0500
Date: Sat, 17 Dec 2011 01:15:17 +0100 (CET)
From: Stefano Laporta <Stefano.Laporta@bo.infn.it>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Stefano Laporta <Stefano.Laporta@bo.infn.it>, linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: 3.1.3 2.6.37.6 2.6.33.4 kernel bug in pata_oldpiix driver
In-Reply-To: <20111128212734.7818a2d6@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LNX.2.00.1112170047330.2197@g-3.bo.infn.it>
References: <alpine.LNX.2.00.1111281823440.12891@g-3.bo.infn.it> <20111128212734.7818a2d6@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (postino.bo.infn.it [131.154.11.5]); Sat, 17 Dec 2011 00:13:16 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have been able to find another similar PC still working, a Pentium 90MHz
with Intel i430FX chipset, 32MB of RAM, an 1.2GB HD and a CD-ROM.
The kernels which crash on my Pentium 133MHz  crash even on the Pentium 90,
  giving exactly the same error messages.

So it seems not to be a problem of a single machine.

I switched on the debug options in kernel configuration, but this makes 
the bug (apparently) disappear. Memory overwrites are always difficult 
to catch.


On Mon, 28 Nov 2011, Alan Cox wrote:

>> BUG: unable to handle kernel paging request at 45230451
>
> That looks like junk from somewhere.
>
>> IP: [<c17bb1f3>] oldpiix_set_dmamode+0xb3/0x120
>
>>   [<c17bb3b0>] ? oldpiix_qc_issue+0x40/0x60
>>   [<c1788d8a>] ? ata_qc_issue+0x1ea/0x330
>
> So we were issuing a command, we called the oldpiix code, it decided that
> the timings were not loaded for this drive (ie it was those loaded for
> the other device on the bus)
>
> It will then have gone into oldpiix_set_piomode which ran succesfully
> implying that ap and adev were valid at that point but seem to have
> mysteriously gone invalid later.
>
> No idea, and the fact that changing things like the pre-empt behaviour or
> build options makes me wonder if it was scribbled on from elsewhere.
>
>
>
