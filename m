Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647Ab1GZOzS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 10:55:18 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56012 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494Ab1GZOzM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 10:55:12 -0400
MIME-Version: 1.0
In-Reply-To: <CADnq5_MKAgmZgSA1t20Spc1YX5MTY+LM66ujmdpJcyngkbYecQ@mail.gmail.com>
References: <CADnq5_M5NAd2PVbS0FPB_VSmg8+41HUsDL1TcbKK94GK6MF_jA@mail.gmail.com>
	<1309995012-5873-1-git-send-email-reimth@gmail.com>
	<1309995012-5873-3-git-send-email-reimth@gmail.com>
	<CADnq5_MCRwTe34MijfN4xBhF98x3J=+4vXPZcvBJX2edsgSaxg@mail.gmail.com>
	<CAPM=9txkD1WKiTKtD1NDygESaX+DAak3avJMGV5DT5NdQRJV5Q@mail.gmail.com>
	<CADnq5_MKAgmZgSA1t20Spc1YX5MTY+LM66ujmdpJcyngkbYecQ@mail.gmail.com>
Date: Tue, 26 Jul 2011 10:55:11 -0400
Message-ID: <CADnq5_MDJ_hHZEJARkinzxbrYpHee=ijQQsQQkjiQ-0dL=zHxg@mail.gmail.com>
Subject: Re: [PATCH 2/3] drm/radeon: Fix Asus M2A-VM HDMI EDID error flooding problem
From: Alex Deucher <alexdeucher@gmail.com>
To: Dave Airlie <airlied@gmail.com>
Cc: reimth@googlemail.com, Dave Airlie <airlied@redhat.com>,
        Mario Kleiner <mario.kleiner@tuebingen.mpg.de>,
        Jean Delvare <khali@linux-fr.org>,
        Tyson Whitehead <twhitehead@gmail.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        stable@kernel.org, Thomas Reim <rdratlos@yahoo.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 10:52 AM, Alex Deucher <alexdeucher@gmail.com> wrote:
> On Tue, Jul 26, 2011 at 9:20 AM, Dave Airlie <airlied@gmail.com> wrote:
>> On Thu, Jul 7, 2011 at 3:01 PM, Alex Deucher <alexdeucher@gmail.com> wrote:
>>> On Wed, Jul 6, 2011 at 7:30 PM,  <reimth@googlemail.com> wrote:
>>>> From: Thomas Reim <rdratlos@yahoo.co.uk>
>>
>> Guys I really still hate this :-)
>>
>> Other OSes must deal with this sort of thing and I can't say they
>> don't do it like this but I can't say for certain this feels like the
>> right answer.
>>
>
> I emailed the closed driver display team, but as the issue seems to
> only afflict certain rs690/rs740 boards, I'm not sure anyone will
> remember what quirks those boards had as they are about 5 generations
> old at this point.

Another possibility is that the closed driver uses the hw i2c engine
which may not be affected, or they just tell the hw i2c engine to
fetch several bytes and they inspect the result similar to what this
patch does.  I'll let you know what I hear back.

>
>> My thinking is that we could probably just trust the hot plug detect
>> if its reported on HDMI and DVI-D connectors, we still need to poll
>> DVI-D as the VGA->DVI convertors don't often assert hpd.
>>
>> Am I missing something that this wouldn't fix?
>
> The issue in this case is that the problematic connectors don't have
> HPD pin wired up and the ddc lines seem to be wired improperly so a
> ddc probe always reports something connected unless you actually look
> at the EDID header.  For DVI-I we probably have to poll since only the
> digital portion will assert hpd in most cases.
>
> Alex
>
