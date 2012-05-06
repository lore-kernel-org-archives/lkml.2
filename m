Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875Ab2EFOeb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 10:34:31 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58711 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706Ab2EFOe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 10:34:29 -0400
MIME-Version: 1.0
In-Reply-To: <20120504134831.GA8263@polaris.bitmath.org>
References: <1336136030-18503-1-git-send-email-benjamin.tissoires@gmail.com>
	<1336136030-18503-5-git-send-email-benjamin.tissoires@gmail.com>
	<20120504134831.GA8263@polaris.bitmath.org>
Date: Sun, 6 May 2012 16:34:28 +0200
Message-ID: <CAN+gG=EfOjm5AX+g22ksFTZhw-rdjT5vWmh0mu6RQZ8oXPCRqw@mail.gmail.com>
Subject: Re: [PATCH 4/5] input: Introduce MT_CENTER_X and MT_CENTER_Y
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>,
        Chase Douglas <chasedouglas@gmail.com>,
        Peter Hutterer <peter.hutterer@who-t.net>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

Well, this is the mail I intended to send yesterday before I run out
of internet connection. This may be useless, but, I'll send it
anyway....

On Fri, May 4, 2012 at 3:48 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> Hi Benjamin, Stephane,
>
>> Microsoft published a new version of their multitouch specification.
>> They introduced a new multitouch field: MT_CENTER_X|Y.
>
> I would like a bit of elaboration here, since I am not convinced the
> mapping should be directly translated to the MT protocol.
>
> Clearly, the basic idea to be able to model an assymmetric tool is
> good. Without an angle description, however, there seems to be a
> mismatch in the degrees of freedom. In win8, one can place the hot
> spot in a corner of the rectangle, but one cannot make the rectangle
> into an ellipse in that direction.

That's not the interpretation I made of the spec.
http://msdn.microsoft.com/library/windows/hardware/br259100

Win8 is a total respin of the multitouch protocol (though backward
compatible). It asks for a lot more reliability and performances for
the devices.
>From what I understood, the T point (the touch) can be an arbitrary
point within the ellipse. Furthermore, the ellipse can be oriented in
an arbitrary rotation (like linux) because they introduced the hid
field Azimuth (0x3f) that is the "Counter-clockwise rotation of the
cursor around the Z axis".

To sum up, there are two kind of information:
- The touch point (where the user wants to touch)
- The elliptic shape of the touch (width, height, center, azimuth, pressure)

I think these two information are interesting as most of the time, the
center of the ellipse is _not_ the point where the user wants to
touch. The best thing to test that is to see how many time you miss
the pixel you want to touch in the current implementation.

I also wanted to publish these 2 last patches to raise the discussion,
and to show that the fix of the randomness in the splitting of the
touches within the reports was compatible with new kinds of devices.

We should focus for now (3.5) on the first 3 patches, and let aside
the 2 last for the next version, when everyone agrees.

Cheers,
Benjamin


> In linux, one can put the ellipse
> in the wanted direction, but the hot spot is always in the center. To
> first order, both models allow for finger-rotation information, but in
> different ways. Adding more parameters requires a bit more
> thought. Perhaps one should use the newly found win8 parameters to
> reshape the pointing ellipse to start with.
>
> Thanks,
> Henrik
