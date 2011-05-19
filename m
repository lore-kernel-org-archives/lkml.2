Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932586Ab1ESHr3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 03:47:29 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33292 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755777Ab1ESHrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 03:47:25 -0400
Date: Thu, 19 May 2011 09:47:22 +0200
From: Borislav Petkov <bp@alien8.de>
To: James <bjlockie@lockie.ca>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: help to bisect
Message-ID: <20110519074722.GD14049@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	James <bjlockie@lockie.ca>,
	Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
References: <4DD31264.4070704@lockie.ca>
 <20110518072245.GB17608@liondog.tnic>
 <4DD42F10.90602@lockie.ca>
 <20110518211723.GA4313@liondog.tnic>
 <4DD45D2D.7060300@lockie.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4DD45D2D.7060300@lockie.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 07:58:37PM -0400, James wrote:
> On 05/18/11 17:17, Borislav Petkov wrote:
> > First of all, please hit "reply-to-all" next time so that all recipients
> > can receive your mail and not find it by chance when looking thru the
> > new lkml messages.
> >
> > On Wed, May 18, 2011 at 04:41:52PM -0400, James wrote:
> >> Here is what I did:
> >>
> >> $ git clone git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.37.y.git
> >> $ cd linux-2.6.37.y
> >> $ git checkout v2.6.36
> >> build and boot kernel
> > what does that mean? Is .36 ok?
> Yes, no problems.
> >> $ cd linux-2.6.37.y
> >> $ git bisect start
> >> $ git bisect good v2.6.36
> >> $ git bisect bad v2.6.37.6
> > Also, is .37.6 bad?
> Yes, it is bad.
> >> build and boot kernel
> >> git bisect good|bad
> >> repeat
> >>
> >> 3044100e58c84e133791c8b60a2f5bef69d732e4 is the first bad commit.
> > Which is a merge commit and it means that you most likely made a mistake
> > during bisection.
> Am I doing it right?
> boot kernel, cd to git source, git bisect good or bad, compile new
> kernel and copy it to /boot,

Dumb question: do you boot into that new kernel and test it each time
before tagging it as good or bad?

> repeat
> > What is actually the problem you're experiencing with .37.6?
> >
> > ..
> >
> >> How do I find out what change causes the problem?
> >> The problem causes my wireless card not to work.
> > Ah, here it is.
> >
> >> Other people have similar cards that do work so the problem seems
> >> isolated to my hardware but kernel-2.6.36 works so I don't think my
> >> hardware is faulty.
> > Which card is that? (adding linux-wireless)
> D-Link dwa552
> ieee80211 phy0: Atheros AR5416 MAC/BB Rev:2 AR2133 RF Rev:81
> mem=0xffffc90000140
> 000, irq=16
> Other people have this card working so it is probably my system
> configuration that is causing an obscure bug.
> 
> > Please, describe in a very detailed way how your problem incarnates
> > itself: dmesg, error messages, what exactly do you do to trigger it?
> It seems to be 100% that if "ath: Failed to stop TX DMA in 100 msec
> after killing last frame
> ath: Failed to stop TX DMA!" shows up in dmesg that scans don't return
> any APs or 1-3 (iwlist wlan0 scan | grep SSID).
> If there is a different way to scan, I'll try that.
> 
> 
> 
> > Also, can you test whether 38.6 works for ya - it could've been fixed in
> > the meantime. You can also test .39 which will be released any minute
> > now.
> 38.6 does NOT work and compat-wireless-2011-05-11 works on kernel-2.6.36
> which is why I think it is the kernel and not the wireless code.
> > I think that should be enough for now.

Aha, here's the deal. You're using compat-wireless which is a bunch of
patches ontop of the kernel so you want to add them to the repository
you're bisecting in so that they can be considered too. Anyway, I've
added Luis to Cc for comment.

@Luis: bug descrption is above.

Btw, there's a newer version against 2.6.39-rc6 which you might want to
test too: http://marc.info/?l=linux-wireless&m=130455450126421&w=2

HTH.

-- 
Regards/Gruss,
    Boris.
