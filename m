Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758144Ab0E1C45 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 22:56:57 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:42192 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755531Ab0E1C4y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 22:56:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=g1u+j5fLGP07EzaPHOwPDtHyzAFBhuWd6VkQV/NIb1y0xR78eRo/mDZ4W04Q7UefBB
         mQXQI6KkY3z0lPpq4nEGSps838b+KPQApzQTXFM69JNvUNTRLIIYuOr6JpJ965z1pIiv
         54sMp8RZNBdbMHEHXHgUrP6U/zFbD+Fh2btT8=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1005271837050.11382@i5.linux-foundation.org>
References: <20100520165243.GA20861@core.coreip.homeip.net>
	<alpine.LFD.2.00.1005271837050.11382@i5.linux-foundation.org>
Date: Fri, 28 May 2010 12:56:53 +1000
Message-ID: <AANLkTiklv48cDWNqKlFfh5RVtxxNH8shH_JjDypPgeHA@mail.gmail.com>
Subject: Re: [git pull] Input updates for 2.6.35-rc0
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Florian Ragwitz <rafl@debian.org>, Arjan Opmeer <arjan@opmeer.net>,
       Eric Piel <eric.piel@tremplin-utc.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 28, 2010 at 11:53 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Thu, 20 May 2010, Dmitry Torokhov wrote:
>>
>> Dmitry Torokhov (17):
>>       Input: elantech - enforce common prefix on messages
>>       Input: elantech - relax signature checks
>
> These two commits (I _think_ - I didn't actually bisect it) seem to result
> in a Dell Inspiron bootup message changing from:
>
>        input: ImPS/2 Logitech Wheel Mouse as /devices/platform/i8042/serio1/input/input5
>
> to
>
>        elantech: assuming hardware version 2, firmware version 4.3.1
>        elantech: Synaptics capabilities query result 0x08, 0x18, 0x0c.
>        input: ETPS/2 Elantech Touchpad as /devices/platform/i8042/serio1/input/input5
>
> and the end result is a total disaster. In the words of my daughter, whose
> laptop this is:
>
>        Subject: Computer=awful
>
>        I am not able to click by tapping, I actually have to press down.. It's
>        really frustrating and I want it fixed.
>
> and having tested it, I have to agree. It's beyond awful. It's absolutely
> disgusting, and the touchpad went from "quite usable" (with tapping,
> double-tapping, scroll-wheel on the right side etc) to "totally unusable".
> The buttons you have to press (since tapping doesn't work) are on the
> touch-pad itself, and it's basically a total pain.
>
> The scroll-wheel emulation still seems to work, but tapping has gone away.
> I'm reading the docs, and they say that you can do magic things with the
> raw registers, but if I'm looking at the register contents they seem to
> say that tapping _is_ enabled. It just doesn't work.
>
> So it would seem that the "non-native" PS/2 emulation of that thing is way
> better than the native driver, and we should _not_ try to treat it as a
> touchpad. We're better off leaving it in ImPS/2 mode.
>

Was this in GNOME?

Does System->Preferences->Mouse have a touchpad tab? do it have tapping off?

Dave.
