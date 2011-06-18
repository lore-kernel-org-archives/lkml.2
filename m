Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab1FRKTG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 06:19:06 -0400
Received: from mta-out.inet.fi ([195.156.147.13]:49243 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753095Ab1FRKTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 06:19:03 -0400
X-Greylist: delayed 376 seconds by postgrey-1.27 at vger.kernel.org; Sat, 18 Jun 2011 06:19:02 EDT
Date: Sat, 18 Jun 2011 13:12:42 +0300
From: Timo Kokkonen <kaapeli@itanic.dy.fi>
To: Mark Knecht <markknecht@gmail.com>
Cc: Paul Hartman <paul.hartman@gmail.com>,
        Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: New Gentoo install on Intel Z68/i7-2600K system hangs after
 VFS:Mounted root...
Message-ID: <20110618101242.GA26761@itanic.dhcp.inet.fi>
References: <BANLkTin8b2suL1675DKvHbeXuCzeCFJeOg@mail.gmail.com>
 <BANLkTin-iYMvbuq=DGo8JZa_vYUMsd24jQ@mail.gmail.com>
 <BANLkTi=NYq7wFqGFuiM_QUtpEZDS5pAuUQ@mail.gmail.com>
 <BANLkTikiszrsC7n-31yUXpMEKHTbWamabw@mail.gmail.com>
 <BANLkTik+yr5gp8TW09-+RbOYnc5RQJ7K0g@mail.gmail.com>
 <BANLkTinEhyN-i0N9QRpdjMUTpMCRiDMDdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTinEhyN-i0N9QRpdjMUTpMCRiDMDdw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.17 2011 14:40:21, Mark Knecht wrote:
> On Fri, Jun 17, 2011 at 12:01 PM, Mark Knecht <markknecht@gmail.com> wrote:
> > On Fri, Jun 17, 2011 at 11:54 AM, Paul Hartman <paul.hartman@gmail.com> wrote:
> >> On Fri, Jun 17, 2011 at 1:29 PM, Mark Knecht <markknecht@gmail.com> wrote:
> >>>   We ran memtest86 for an hour. Completed a couple of passes with no
> >>> errors. Will run more later but no obvious memory problems seen.
> >>>
> >>>   I installed 2.6.39-gentoo-r1. No change from 2.6.38-gentoo-r6.
> >>> Stops at the same place.
> >>>
> >>>   I tried 2.6.39-gentoo-r1 with no kernel options, and with all
> >>> combinations of nousb and acpi=off. All 4 attempts quit at the same
> >>> place.
> >>
> >> Check out this forum post, this person's bootup seems to stop in the
> >> same place as yours. He was able to fix it by booting off a liveCD and
> >> manually creating device nodes. Maybe it's nothing, but probably worth
> >> looking at just in case it might help.
> >>
> >> https://www.linuxquestions.org/questions/gentoo-87/booting-stops-after-kernel-starts-883031/
> >>
> >
> > Argh!! I remember a post like that on the Gentoo list. I'll check if
> > out and give it a try.
> >
> > Thnaks,
> > Mark
> >
> Thanks again Paul. That was exactly the solution I needed.
> 
> I remember this thread, or one like it, on the Gentoo-user list, but I
> didn't follow the thread. I just remember that the Gentoo tarball was
> not created correctly and these devices were left out. Adding them in
> solved all the problem. 

There is also another solution for this. You can enable the devtmpfs
(and also the optioin to auto mount it during boot) in order to make
kernel create all necessary device nodes under the /dev
automatically. Then you don't need your distro to generate initial
device nodes prior starting udev. I don't know if the Gentoo devs have
somehow relied on devtmpfs because the recent stage tar balls don't
seem to contain the initial device nodes anymore.

-Timo
