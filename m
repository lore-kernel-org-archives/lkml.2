Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab1AUHq3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 02:46:29 -0500
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:52016 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754171Ab1AUHq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 02:46:27 -0500
Date: Fri, 21 Jan 2011 13:15:30 +0530
From: "G, Manjunath Kondaiah" <manjugk@ti.com>
To: Govindraj <govindraj.ti@gmail.com>
Cc: Anand Gadiyar <gadiyar@ti.com>, Manjunath Kondaiah G <manjugk@ti.com>,
        Thomas Weber <weber@corscience.de>, linux-omap@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>,
        Govindraj Raja <govindraj.raja@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Andrei Emeltchenko <andrei.emeltchenko@nokia.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] OMAP: Enable Magic SysRq on serial console ttyOx
Message-ID: <20110121074530.GB12307@m-desktop>
References: <1295426461-12459-1-git-send-email-weber@corscience.de>
 <AANLkTin0-joNuqxqL79j0wqPk_A5mtAgzEY=X=PeH=+C@mail.gmail.com>
 <20110119130049.GB9365@m-desktop>
 <4D36E7CC.5090303@corscience.de>
 <AANLkTikjdukQ+kUUR7N11rZ5b=Xd=xLb0-chMrbp5BQ6@mail.gmail.com>
 <20110120114855.GD1987@m-desktop>
 <38f2b3af600ce3dfea1e73edec7c81fa@mail.gmail.com>
 <AANLkTimxTaU3x9DZvL4dvXs1nTYjCQnbyZLC73SOKrgQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimxTaU3x9DZvL4dvXs1nTYjCQnbyZLC73SOKrgQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21, 2011 at 12:54:29PM +0530, Govindraj wrote:
> On Thu, Jan 20, 2011 at 5:49 PM, Anand Gadiyar <gadiyar@ti.com> wrote:
> >> > >>>> Magic SysRq key is not working for OMAP on new serial
> >> > >>>> console ttyOx because SUPPORT_SYSRQ is not defined
> >> > >>>> for omap-serial.
> >> > >>>>
> >> > >>>> This patch defines SUPPORT_SYSRQ in omap-serial and
> >> > >>>> enables handling of Magic SysRq character.
> >> > >>>>
> >> > >>>> Signed-off-by: Thomas Weber <weber@corscience.de>
> >> > >>>
> >> > >>> Looks fine to me.
> >> > >>>
> >> > >>> Acked-by: Govindraj.R <govindraj.raja@ti.com>
> >> > >> I tried to use SysRq key on minicom after applying this patch, it
> > looks
> >> > >> like it is not triggering sysrq event.
> >> > >>
> >> > >> Am I missing anything?
> >> > >>
> >> > >> -Manjunath
> >> > >> --
> >> > > Hello Manjunath,
> >> > >
> >> > > Do you have CONFIG_MAGIC_SYSRQ enabled?
> >> > > Magic SysRq key in Kernel Hacking
> >> > >
> >> > > I tested it on Devkit8000 (beagle board clone).
> >> > >
> >> >
> >> > re-setting lsr_break_flag to 0 in receive chars is causing issues
> >> > in getting sysrq key break sequence on omap-serial.c
> >> >
> >> > Manju,
> >> >
> >> > can you try this change on your environment.
> >> > With below change works for me on 3430SDP/4430SDP.
> >> > key sequence I checked.
> >> > [alt + b + t]  => shows trace of tasks running.
> >> > [alt + b + b] => system reboot.
> >>
> >> With below patch, it works fine on TeraTerm. However, I am not able to
> >> perform the same on minicom.
> >>
> >> Tested-by: Manjunath G Kondaiah <manjugk@ti.com>
> >>
> >> -Manjunath
> >>
> >
> > Not sure what you guys are trying out, but I am able to use sysrq
> > just fine in minicom (using only Thomas' original patch) - you need
> > to send a break sequence, and the way to do this in minicom is to
> > do Ctrl-A followed by F.
> >
> > Works for me, without the "resetting lsr_break_flag to 0" part.
> >
> > @Govind,
> >
> > What are the issues you see in getting sysrq key break sequence
> > without your change? And how is your change fixing this?
> 
> Actually I was using teraterm on windows platform.
> using keyboard to send a break char [alt + b] sometimes
> i observed that first break char was getting lost and subsequent break
> chars where getting
> recognized. However using send break option from terterm menu seems to
> work most of times.
> my change can be dropped.
If it is fixing the issue of losing first break character, what is wrong in
having this patch?

Do you see any other issues because of this change?

-Manjunath

