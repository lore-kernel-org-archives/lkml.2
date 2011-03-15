Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207Ab1COISz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 04:18:55 -0400
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:50839 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753207Ab1COISu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 04:18:50 -0400
Message-ID: <4D7F20D6.5040703@fastmail.fm>
Date: Tue, 15 Mar 2011 09:18:30 +0100
From: Anders Eriksson <aeriksson@fastmail.fm>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20101003 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
To: Alex Deucher <alexdeucher@gmail.com>
CC: airlied@redhat.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, xorg-driver-ati@lists.x.org
Subject: Re: Radeon jittery post 2.6.35
References: <4D7CCFC3.7030906@fastmail.fm> <AANLkTinug=6d6BKrZvA1HGZWNqgUNJKOBC3f8J5B_5oJ@mail.gmail.com>
In-Reply-To: <AANLkTinug=6d6BKrZvA1HGZWNqgUNJKOBC3f8J5B_5oJ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.252.238.16
X-Scan-Result: No virus found in message 1PzPSh-0001ub-CM.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PzPSh-0001ub-CM f4299868e3388c8095f5f7e5829dab34
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 03/14/11 23:20, Alex Deucher wrote:
> On Sun, Mar 13, 2011 at 10:08 AM, Anders Eriksson <aeriksson@fastmail.fm> wrote:
>>  Hi,
>>
>> I've found what I guess is a radeon (or drm/kms) regression post 2.6.35.
>> I've got my TV conneced to my RS690G over HDMI, and the display has
>> always been jittery after POST and at the GRUB screen. Pre-KMS, the X
>> server (or driver got it sorted), and when KMS started, the display
>> stabilized right after the kernel driver was initiated. However, post
>> 2.6.35, I see the jitter is back.
>>
>> I've spent the last month trying to bisect it, but pretty much failed.
>> It appears that versions closer to 2.6.38-rcX are more prone to display
>> jitter, while 2.6.36 or so can have many successful runs. It also
>> appears to be related to device power-on order, or so I've come to
>> believe; A stable display can turn jittery, just by power cycling the TV.
>>
>> I've uploaded a video of a 38-rc8 boot:
>> http://www.easy-share.com/1914220540/2.6.38-rc8_bad_x.mp4
>>
>> You'll see jitter at the POST screen and GRUB. When KMS kicks in it
>> stabilizes, and when Freevo starts X, it's back to jitter.
> Does plain X or gnome/kde jitter too or just freevo?
>
Yes. A plain xinit with an xterm without window manager shows the same
thing. (I run freevo on on X, not fb)

Btw, These are the X packages I use:
libXxf86misc-1.0.3
libXxf86dga-1.1.2
libXxf86vm-1.1.1
xf86dga-1.0.3
xf86vidmodeproto-2.3.1
xf86miscproto-0.9.3
xf86dgaproto-2.1
xf86bigfontproto-1.2.0
xf86driproto-2.1.1
xf86rushproto-1.1.2
xf86-input-evdev-2.6.0
xf86-video-ati-6.14.0
xf86-input-keyboard-1.5.0
xf86-input-mouse-1.6.0

> Alex
>
>> The jitter is always of the same kind. It looks like an old tv set which
>> loses sync. The contents on the display is, for a split second, placed
>> at the wrong part of the screen (vertically and to some extent
>> horizontally), and every 5-15 seconds or so, there is a big reset when
>> the TV tries to restart things (I guess). At the resets, thee is a loud
>> 'ping' in the nearby stereo too...
>>
>> During the bisect  (and a t 38-rc8) I've seen this both at the console
>> (post KMS) and in X, so I'm not sure where the error is. I hope some of
>> you can get a better idea of where to hunt for the bug by looking at the
>> video.
>>
>> -Anders
>>

