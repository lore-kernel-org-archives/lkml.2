Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145Ab2LLUE5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 15:04:57 -0500
Received: from smtprelay.restena.lu ([158.64.1.62]:42085 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab2LLUEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 15:04:55 -0500
Date: Wed, 12 Dec 2012 21:04:34 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Jacek Poplawski <jacekpoplawski@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: "attempt to access beyond end of device" on DVD
Message-ID: <20121212210434.5cadf42c@neptune.home>
In-Reply-To: <CAGDELX6CPevOq8EowLu1GUwiS6Yw4vjOz3S2AOewFBbt0pC_dw@mail.gmail.com>
References: <CAGDELX7f-Ee-V_M8kbDONRFCTBbZM2H_Q17Bk_12r4xw85Wq4Q@mail.gmail.com>
	<20121212014109.38e18eeb@neptune.home>
	<CAGDELX6rtztDzQobfaUNB2iZSyxGL9vzu5mM4sG7bDip=SaBag@mail.gmail.com>
	<20121212020348.0afa77e2@neptune.home>
	<CAGDELX6L89ux2TXJLnm5aC2zNdSqQDZws+c5-OA0Xbtkt7Nw5g@mail.gmail.com>
	<CAGDELX6CPevOq8EowLu1GUwiS6Yw4vjOz3S2AOewFBbt0pC_dw@mail.gmail.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.12; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 December 2012 Jacek Poplawski <jacekpoplawski@gmail.com> wrote:
> OK, I was wrong previously.
> 
> I don't need to reload sr_mod, I only need to remount DVD.
> 
> The reason I was wrong is I was suspecting that DVD remounts itself
> after eject, but looks like it doesn't. Also it means that the problem
> is different than 3 years ago, because I am sure I was remounting DVD
> by hand and now I use some automount feature of Arch Linux / GNOME3.

What kind of filesystem do you have on your CD/DVDs?

[CCing linux-fsdevel as it seems like it may be a isofs or udf issue]

Bruno

> On 12/12/12, Jacek Poplawski <jacekpoplawski@gmail.com> wrote:
> >> Did you check if unbinding drivers or unloading their modules has the
> >> same effect as rebooting? That might help narrowing the area of code to
> >> look at.
> >
> > You were right.
> > I unmounted the DVD, then removed module sr_mod, reloaded it, inserted
> > DVD again and copied missing files, now they are OK.
> >
> >
> >> While at it, please tell us how your CD/DVD drive is connected and which
> >> controller it's connected to (relevant dmesg parts).
> >
> > [    0.893465] ata5.00: ATAPI: Optiarc DVD RW AD-7203S, 1.05, max UDMA/100
> > [    0.906796] ata5.00: configured for UDMA/100
> > (...)
> > [    1.232096] scsi 4:0:0:0: CD-ROM            Optiarc  DVD RW
> > AD-7203S  1.05 PQ: 0 ANSI: 5
> > (...)
> > [  897.871546] sr0: scsi3-mmc drive: 125x/125x writer dvd-ram cd/rw
> > xa/form2 cdda tray
> > [  897.871726] sr 4:0:0:0: Attached scsi CD-ROM sr0
> >
> > I don't have other devices to test (and haven't tried loop device).
> >
