Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209Ab1B0PYH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 10:24:07 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:39886 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122Ab1B0PYD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 10:24:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=ErE1uVqBeWjjOjUZM9lBcImAhq7veo9+ya96s1fEBLaosJKa5t+QkUlwv8KtJ8GCge
         wYhZZMZiDWNdWJdEPyXGX9VmfMaXy3DAaU1wROUQxyIaF11B0ER4Fn9TS6LH8x4Rjz4F
         XUAnFXFvA84C1csAF59kmpkm6CVENDZPSP248=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20110225222210.GA3618@tuxdriver.com>
References: <20110225222210.GA3618@tuxdriver.com>
Date: Sun, 27 Feb 2011 16:23:59 +0100
Message-ID: <AANLkTingkcc-dvs_8Nr0vYXdXvuDHEn6sz14tnHzLp8W@mail.gmail.com>
Subject: Re: ANNOUNCE: debloat-testing kernel git tree
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, bloat-devel@lists.bufferbloat.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 11:22 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> Announcement
>
> The bufferbloat project [1] is pleased to announce the availability
> of the debloat-testing Linux kernel git tree:
>
>        git://git.infradead.org/debloat-testing.git
>
> The purpose of this tree is to provide a reasonably stable base for
> the development and testing of new algorithms, miscellaneous fixes,
> and maybe a few hacks intended to advance the cause of eliminating
> or at least mitigating bufferbloat in the Linux world.
>
> Introduction
>
> Bufferbloat is a term coined by Jim Gettys to describe the increasing
> prevalence of large and (particularly) unmanaged network buffers along
> the network links that comprise the Internet [2].  If you are not aware
> of the problems with network latency under load that the Internet is
> already encountering, we encourage you to visit Jim Gettys' blog [3].
> There Jim has begun to fit together enough puzzle pieces to at least
> frame the issue.
>
> Jim has also made available slides and an audio recording (edited
> for time) from a presentation on this topic:
>
>        http://mirrors.bufferbloat.net/Talks/BellLabs01192011/
>
> Kernel Bits
>
> The debloat-testing tree is intended to track full and -rc releases
> from linux-2.6, with interesting patches cherry-picked from net-next
> and various experimental bits added on top.  The current stable of
> such patches includes the following:
>
> Eric Dumazet (based on original work by Juliusz Chroboczek):
>      net_sched: SFB flow scheduler
>
> stephen hemminger:
>      sched: CHOKe flow scheduler
>
> John Fastabend:
>      net: implement mechanism for HW based QOS
>      net_sched: implement a root container qdisc sch_mqprio
>
> John W. Linville:
>      mac80211: implement eBDP algorithm to fight bufferbloat
>
> Nathaniel J. Smith:
>      iwlwifi: Simplify tx queue management
>      iwlwifi: Convert the tx queue high_mark to an atomic_t
>      iwlwifi: Invert the sense of the queue high_mark
>      iwlwifi: auto-tune tx queue size to minimize latency
>      iwlwifi: make current tx queue sizes visible in debugfs
>
> Dave Taht:
>      Bufferbloat reduction for the e1000 driver that started it all
>      Reduce bufferbloated default for e1000e, increase dynamic range
>      Smash bufferbloat in the ath9k driver
>
> Userland Bits
>
> Patches for the userspace tc utility incorporating support for both the
> CHOKe AQM and the Stochastic Fair Blue scheduler (SFB) are available:
>
>        https://github.com/dtaht/iproute2bufferbloat
>
> Contributions
>
> Please send any experimental or research-oriented patches related to
> bufferbloat to the bloat-devel@lists.bufferbloat.net list.  Reminders
> of more mainstream patches that may be relevant and/or interesting
> for cherry-picking into debloat-testing are welcome there as well.
>
> Obviously, patches that are ready for normal merge consideration
> should continue to be sent to netdev, linux-wireless, linux-kernel,
> or whatever other existing list is appropriate for them.
>
> Thanks
>
> Finally, we want to offer a huge thanks to the 130+ new members of
> the bloat mailing list [4] for leaping into the fray, and to David
> Woodhouse for hosting the debloat-testing tree at infradead.
>
> Please help us beat the bloat.  Good luck, and happy debloating!
>
> Notes
>
> [1] http://bufferbloat.net
> [2] http://gettys.wordpress.com/what-is-bufferbloat-anyway/
> [3] http://en.wordpress.com/tag/bufferbloat/
> [4] https://lists.bufferbloat.net
> --
> John W. Linville                Someday the world will need a hero, and you
> linville@tuxdriver.com                  might be all we have.  Be ready.
>

Hi,

it should be "localversion-debloat" in the commit-subject in [1] (not
"localversion-wireless") :-).
"-db" as suffix is IMHO not very meaningful... Why not add simply a
suffix called "-debloat"?
(Anyway, I will revert this patch because I don't want to have any
suffix added automatically.)

I have several other questions, but I start compiling first and test
this debloat kernel.

Regards,
- Sedat -

[1] "Add localversion-wireless to identify builds from this tree."
http://git.infradead.org/debloat-testing.git/commit/3f9bdb4f44b076feda72d353d8ad717831416f36
