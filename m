Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758640Ab1COVq1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 17:46:27 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:48756 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756163Ab1COVqY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 17:46:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sMg02X1slU0ke9VLhP1Jquu9oXfv2cTZvILlRl3SYaerVoPJQJaYmlJijCnVOMEPCP
         5SodzC+8Rn6/g0oRYbK9WnG3NHWIgBmB2tGElR/qR1b3emTfuZQFAQPCVPBfu2c3oR/B
         OH3vqsdDDwQaSYfQqXSENxVqrqnd0M84c9LdM=
MIME-Version: 1.0
In-Reply-To: <4D7FD2FB.9090505@fastmail.fm>
References: <4D7CCFC3.7030906@fastmail.fm>
	<AANLkTinug=6d6BKrZvA1HGZWNqgUNJKOBC3f8J5B_5oJ@mail.gmail.com>
	<AANLkTik0nXX+WEwa2xZ9VV+yHwrWnx+tYNdZXPEjk=SO@mail.gmail.com>
	<4D7FD2FB.9090505@fastmail.fm>
Date: Tue, 15 Mar 2011 17:46:23 -0400
Message-ID: <AANLkTimboMAFkqTUOwP9m2z361TM_EgthQO07T5Y_az1@mail.gmail.com>
Subject: Re: Radeon jittery post 2.6.35
From: Alex Deucher <alexdeucher@gmail.com>
To: Anders Eriksson <aeriksson@fastmail.fm>
Cc: airlied@redhat.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, xorg-driver-ati@lists.x.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 4:58 PM, Anders Eriksson <aeriksson@fastmail.fm> wrote:
>  On 03/14/11 23:22, Alex Deucher wrote:
>> On Mon, Mar 14, 2011 at 6:20 PM, Alex Deucher <alexdeucher@gmail.com> wrote:
>> > On Sun, Mar 13, 2011 at 10:08 AM, Anders Eriksson <aeriksson@fastmail.fm> wrote:
>> >>  Hi,
>> >>
>> >> I've found what I guess is a radeon (or drm/kms) regression post 2.6.35.
>> >> I've got my TV conneced to my RS690G over HDMI, and the display has
>> >> always been jittery after POST and at the GRUB screen. Pre-KMS, the X
>> >> server (or driver got it sorted), and when KMS started, the display
>> >> stabilized right after the kernel driver was initiated. However, post
>> >> 2.6.35, I see the jitter is back.
>> >>
>> >> I've spent the last month trying to bisect it, but pretty much failed.
>> >> It appears that versions closer to 2.6.38-rcX are more prone to display
>> >> jitter, while 2.6.36 or so can have many successful runs. It also
>> >> appears to be related to device power-on order, or so I've come to
>> >> believe; A stable display can turn jittery, just by power cycling the TV.
>> >>
>
> Some further testing on a clean rc8 suggests that the jitter seen
> there can  reliably be removed by power cycling the TV while in X,
> or starting X with the TV off.
>
> I'm tempted to think that something makes too much out of bad
> info collected from the TV, and falls backs to saner defaults if
> the TV has nothing to say.
>
> I've seen in the logs that the EDID is disliked:
> [drm:radeon_dvi_detect] *ERROR* HDMI-A-1: probed a monitor but
> no|invalid EDID
> Not sure if that is related though (cannot seem to be able to provoke
> that error message right now)

Try booting with radeon.audio=0 on 2.6.38rc, some TVs have problems
with the hdmi packets we send by default.  disabling audio will treat
the hdmi like dvi.

Alex

>
> -A
>
>
>
>
