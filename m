Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758800Ab1COVEv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 17:04:51 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:48223 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757784Ab1COVEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 17:04:44 -0400
Message-ID: <4D7FD2FB.9090505@fastmail.fm>
Date: Tue, 15 Mar 2011 21:58:35 +0100
From: Anders Eriksson <aeriksson@fastmail.fm>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20101003 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
To: Alex Deucher <alexdeucher@gmail.com>
CC: airlied@redhat.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, xorg-driver-ati@lists.x.org
Subject: Re: Radeon jittery post 2.6.35
References: <4D7CCFC3.7030906@fastmail.fm>	<AANLkTinug=6d6BKrZvA1HGZWNqgUNJKOBC3f8J5B_5oJ@mail.gmail.com> <AANLkTik0nXX+WEwa2xZ9VV+yHwrWnx+tYNdZXPEjk=SO@mail.gmail.com>
In-Reply-To: <AANLkTik0nXX+WEwa2xZ9VV+yHwrWnx+tYNdZXPEjk=SO@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.252.238.16
X-Scan-Result: No virus found in message 1PzbKJ-0006EM-9b.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1PzbKJ-0006EM-9b 89c9f919a3c047f14de9d9c82644281a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 03/14/11 23:22, Alex Deucher wrote:
> On Mon, Mar 14, 2011 at 6:20 PM, Alex Deucher <alexdeucher@gmail.com> wrote:
> > On Sun, Mar 13, 2011 at 10:08 AM, Anders Eriksson <aeriksson@fastmail.fm> wrote:
> >>  Hi,
> >>
> >> I've found what I guess is a radeon (or drm/kms) regression post 2.6.35.
> >> I've got my TV conneced to my RS690G over HDMI, and the display has
> >> always been jittery after POST and at the GRUB screen. Pre-KMS, the X
> >> server (or driver got it sorted), and when KMS started, the display
> >> stabilized right after the kernel driver was initiated. However, post
> >> 2.6.35, I see the jitter is back.
> >>
> >> I've spent the last month trying to bisect it, but pretty much failed.
> >> It appears that versions closer to 2.6.38-rcX are more prone to display
> >> jitter, while 2.6.36 or so can have many successful runs. It also
> >> appears to be related to device power-on order, or so I've come to
> >> believe; A stable display can turn jittery, just by power cycling the TV.
> >>

Some further testing on a clean rc8 suggests that the jitter seen
there can  reliably be removed by power cycling the TV while in X,
or starting X with the TV off.

I'm tempted to think that something makes too much out of bad
info collected from the TV, and falls backs to saner defaults if
the TV has nothing to say.

I've seen in the logs that the EDID is disliked:
[drm:radeon_dvi_detect] *ERROR* HDMI-A-1: probed a monitor but
no|invalid EDID
Not sure if that is related though (cannot seem to be able to provoke
that error message right now)

-A



