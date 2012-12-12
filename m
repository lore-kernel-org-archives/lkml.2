Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab2LLCAV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 21:00:21 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:53952 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978Ab2LLCAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 21:00:20 -0500
X-Greylist: delayed 1312 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Dec 2012 21:00:19 EST
MIME-Version: 1.0
In-Reply-To: <20121212020348.0afa77e2@neptune.home>
References: <CAGDELX7f-Ee-V_M8kbDONRFCTBbZM2H_Q17Bk_12r4xw85Wq4Q@mail.gmail.com>
	<20121212014109.38e18eeb@neptune.home>
	<CAGDELX6rtztDzQobfaUNB2iZSyxGL9vzu5mM4sG7bDip=SaBag@mail.gmail.com>
	<20121212020348.0afa77e2@neptune.home>
Date: Wed, 12 Dec 2012 02:38:25 +0100
Message-ID: <CAGDELX6L89ux2TXJLnm5aC2zNdSqQDZws+c5-OA0Xbtkt7Nw5g@mail.gmail.com>
Subject: Re: "attempt to access beyond end of device" on DVD
From: Jacek Poplawski <jacekpoplawski@gmail.com>
To: =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Did you check if unbinding drivers or unloading their modules has the
> same effect as rebooting? That might help narrowing the area of code to
> look at.

You were right.
I unmounted the DVD, then removed module sr_mod, reloaded it, inserted
DVD again and copied missing files, now they are OK.


> While at it, please tell us how your CD/DVD drive is connected and which
> controller it's connected to (relevant dmesg parts).

[    0.893465] ata5.00: ATAPI: Optiarc DVD RW AD-7203S, 1.05, max UDMA/100
[    0.906796] ata5.00: configured for UDMA/100
(...)
[    1.232096] scsi 4:0:0:0: CD-ROM            Optiarc  DVD RW
AD-7203S  1.05 PQ: 0 ANSI: 5
(...)
[  897.871546] sr0: scsi3-mmc drive: 125x/125x writer dvd-ram cd/rw
xa/form2 cdda tray
[  897.871726] sr 4:0:0:0: Attached scsi CD-ROM sr0

I don't have other devices to test (and haven't tried loop device).
