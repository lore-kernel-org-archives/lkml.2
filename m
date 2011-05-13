Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757085Ab1EMVUz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 17:20:55 -0400
Received: from novprvlin0050.provo.novell.com ([137.65.248.33]:41630 "EHLO
	novprvlin0050.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751148Ab1EMVUy (ORCPT
	<rfc822;groupwise-jlee@novell.com:5:1>);
	Fri, 13 May 2011 17:20:54 -0400
Message-Id: <4DCE2D4D020000230002C96A@novprvlin0050.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Fri, 13 May 2011 15:20:45 -0600
From: "Joey Lee" <jlee@novell.com>
To: "Michael Chang" <MChang@novell.com>
Cc: <chris@chris-wilson.co.uk>, <dri-devel@lists.freedesktop.org>,
        <tiwai@suse.de>, <linux-kernel@vger.kernel.org>
Subject: Re: i915/kms/backlight-combo mode problem
References: <BANLkTimXkXCAKQGK2ysTRNN-xa4ZChxcHA@mail.gmail.com>
 <BANLkTimtvAWeS-t3bWjJmdVtyaPDw2uWDA@mail.gmail.com>
 <BANLkTi=hUBrKnbrF+Q_ZOxdUPVSOUYUm2Q@mail.gmail.com>
 <201105101308.24662@rk-nord.at>
 <BANLkTimQJM3N1WdBhYVOH0UyyOTFcxOfUQ@mail.gmail.com>
In-Reply-To: <BANLkTimQJM3N1WdBhYVOH0UyyOTFcxOfUQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forward to upstream for more discussion.

於 五，2011-05-13 於 17:27 +0800，Michael Chang 提到：
> Melchior,
> 
> I tried to puzzle out the possible cause of the problem, but sorry
> that no further progress to give you. I'd like to debug this issue,
> also did Joey. But there's more questions in my mind, made me feel not
> able to proceed any further.. :(
> 
> 1. is_backlight_combination_mode() really returns 0x4 ..? I understand
> your words, but if this is true then Joey Lee provided patch should
> log out some information about changing the LPBC
> 
>   set backlight lbpc = ...
> 
> but I didn't see any of the log output .. :(
> 
> 2.  I dig the old mailing thread .. found a post
> 
> http://marc.info/?l=linux-kernel&m=130462815211684&w=2
> 
> If you rebase this patch to your currently git commit, will it fixes
> all problems for you now (only vanilla kernel with this patch)? (You
> replied that this patch works for you ..) Also another interesting
> finding...
> 
> > +	if (!lbpc)
> > +		combo_mode = 0;
> 
> Looks like the purpose of it is to NOT touch the LPBC registers if
> lbpc is zero ...(since this forces is_backlight_combination_mode
> return 0). This would make contradiction about the assumption that you
> could change to back-light via LPBC ..   (using setpci is actually
> access the LPBC registers .. IMHO).
> 
> Total a mess for me now .. Did I made anything wrong .. I know I may
> lose some details.
> 
> I'm thinking is it ok for us to discuss in IRC, the communication
> would be more efficient. Would this be convenient for you ? This is up
> to you.
> 
> Have nice weekend .. :)
> 
> Regards,
> Michael Chang
> 
> 2011/5/10 Melchior FRANZ <melchior.franz@gmail.com>:
> > * Michael Chang -- Tuesday 10 May 2011:
> >> Could you please try this patch and get the log ? We wonder why
> >> is_backlight_combination_mode () returns false.
> >
> > This information was already buried in the bugzilla thread:
> >
> >  https://bugzilla.kernel.org/show_bug.cgi?id=31522
> >  "It turned out that on this machine INTEL_INFO(dev)->gen equals 4,
> >  and is_backlight_combination_mode() returns 0x40000000."
> >
> >
> > But to say it again in your words:   :-)
> >
> >  [drm:is_backlight_combination_mode], BLM_COMBINATION_MODE = 1073741824  (0x40000000)
> >
> > 6x during boot-up, and several times later when changing the backlight
> > brightness.
> >
> >
> > This was with 8b061610dac3a3b89770c85ad63b481a47b0c38e. And now
> > I have a little shocker for you (and me): because this was a
> > vanilla kernel (apart from these debug messages), the screen went
> > black again, like I knew it. But pressing the "brightness down"
> > key turns the backlight on! I can't believe that I haven't tested
> > that. I guess I've only tried "brightness up" and "display toggle".
> > Those don't turn backlight on. Or maybe somethine else relevant
> > meanwhile changed in the i915 drivers. (I've regularly been
> > updating to HEAD.)
> >
> > So, the problem was just the initial state all the time?
> >
> > m.
> >


