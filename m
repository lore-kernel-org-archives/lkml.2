Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531Ab1ATMTr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 07:19:47 -0500
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:40602 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755455Ab1ATMTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 07:19:46 -0500
From: Anand Gadiyar <gadiyar@ti.com>
References: <1295426461-12459-1-git-send-email-weber@corscience.de>
 <AANLkTin0-joNuqxqL79j0wqPk_A5mtAgzEY=X=PeH=+C@mail.gmail.com>
 <20110119130049.GB9365@m-desktop> <4D36E7CC.5090303@corscience.de>
 <AANLkTikjdukQ+kUUR7N11rZ5b=Xd=xLb0-chMrbp5BQ6@mail.gmail.com> <20110120114855.GD1987@m-desktop>
MIME-Version: 1.0
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <20110120114855.GD1987@m-desktop>
Thread-Index: Acu4mDQrT2cAh/qhSPWa88FMVTiRtwAA6ynw
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Date: Thu, 20 Jan 2011 17:49:42 +0530
Message-ID: <38f2b3af600ce3dfea1e73edec7c81fa@mail.gmail.com>
Subject: RE: [PATCHv2] OMAP: Enable Magic SysRq on serial console ttyOx
To: Manjunath Kondaiah G <manjugk@ti.com>, Govindraj <govindraj.ti@gmail.com>
Cc: Thomas Weber <weber@corscience.de>, linux-omap@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>,
        Govindraj Raja <govindraj.raja@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Andrei Emeltchenko <andrei.emeltchenko@nokia.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > >>>> Magic SysRq key is not working for OMAP on new serial
> > >>>> console ttyOx because SUPPORT_SYSRQ is not defined
> > >>>> for omap-serial.
> > >>>>
> > >>>> This patch defines SUPPORT_SYSRQ in omap-serial and
> > >>>> enables handling of Magic SysRq character.
> > >>>>
> > >>>> Signed-off-by: Thomas Weber <weber@corscience.de>
> > >>>
> > >>> Looks fine to me.
> > >>>
> > >>> Acked-by: Govindraj.R <govindraj.raja@ti.com>
> > >> I tried to use SysRq key on minicom after applying this patch, it
looks
> > >> like it is not triggering sysrq event.
> > >>
> > >> Am I missing anything?
> > >>
> > >> -Manjunath
> > >> --
> > > Hello Manjunath,
> > >
> > > Do you have CONFIG_MAGIC_SYSRQ enabled?
> > > Magic SysRq key in Kernel Hacking
> > >
> > > I tested it on Devkit8000 (beagle board clone).
> > >
> >
> > re-setting lsr_break_flag to 0 in receive chars is causing issues
> > in getting sysrq key break sequence on omap-serial.c
> >
> > Manju,
> >
> > can you try this change on your environment.
> > With below change works for me on 3430SDP/4430SDP.
> > key sequence I checked.
> > [alt + b + t]  => shows trace of tasks running.
> > [alt + b + b] => system reboot.
>
> With below patch, it works fine on TeraTerm. However, I am not able to
> perform the same on minicom.
>
> Tested-by: Manjunath G Kondaiah <manjugk@ti.com>
>
> -Manjunath
>

Not sure what you guys are trying out, but I am able to use sysrq
just fine in minicom (using only Thomas' original patch) - you need
to send a break sequence, and the way to do this in minicom is to
do Ctrl-A followed by F.

Works for me, without the "resetting lsr_break_flag to 0" part.

@Govind,

What are the issues you see in getting sysrq key break sequence
without your change? And how is your change fixing this?


- Anand
