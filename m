Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020Ab1CYPnP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 11:43:15 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54795 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576Ab1CYPnO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 11:43:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kuZu6a2LpDYccubPVDBkgNAvxo/vPoxYjeATpdHHABrJ5elCaayvC5TJ2RjQLVOriD
         M2PVFn64fuAs6zP8aFNRbF6JgwiK37WzBEg9j3G56CXq6wd0tuwCjdi3nAgi3Sc6hDob
         1BoZgAuBr9eMd0FpsatFoJpkxGIm/vf+GuNHs=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=iWeKVww_XPm0PQa09NLtPCo4wvz7ZYkk1ajhQ@mail.gmail.com>
References: <20110324195720.GB31713@thinkpad-t410>
	<1300997035-14104-2-git-send-email-seth.forshee@canonical.com>
	<AANLkTimF2UR8BVQW-3YJaGFEz39q8ydESAiMOjmdM1X7@mail.gmail.com>
	<20110325135311.GA14328@thinkpad-t410>
	<AANLkTin3MDYdL6x1Qs8Q9oMMgDMfsoO2GjWMJO_65GAR@mail.gmail.com>
	<AANLkTi=iWeKVww_XPm0PQa09NLtPCo4wvz7ZYkk1ajhQ@mail.gmail.com>
Date: Fri, 25 Mar 2011 15:43:11 +0000
Message-ID: <AANLkTinr2FJA2H3CJWx-wZ_g-hCZ3DT7PR6QsXqi5Rkw@mail.gmail.com>
Subject: Re: [PATCH 2/2] eeepc-wmi: Add support for T101MT Home/Express Gate key
From: Corentin Chary <corentin.chary@gmail.com>
To: Chris Bagwell <chris@cnpbagwell.com>
Cc: Matthew Garrett <mjg@redhat.com>, acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Seth Forshee <seth.forshee@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Here is how I envision using these keys.  I wanted to map quick press
> to GNOME3/KDE4/Unity's Activities menu and map press-and-hold to
> script that rotates screen.  I like the repeating of rotates but I
> didn't really want a rotate to also force a pop up of the activities
> menu.

Makes sense.

>>
>>> And back to the question of KEY_HOME -- that's not really what you want,
>>> is it? As in "move cursor to start of line"?
>>
>> Ho .. right, that's what mean KEY_HOME :/. So no, I don't want that...
>> What about:
>> - KEY_CYCLEWINDOWS
>> - KEY_COMPUTER
>> - KEY_HOMEPAGE
>> - KEY_DASHBOARD
>>
>> I think KEY_HOMEPAGE is the best choice.
>
> I've only had limited time to look more.  So far, I found under udev a
> toshiba tablet that maps what is probably a rotate button to
> KEY_DIRECTION so thats one option for it instead of KEY_PROG2.  I
> couldn't find anybody using that though.
>
> I see in /usr/share/X11/symbols/inet:
>
>    key <I162>   {      [ XF86RotateWindows     ]       };
>
> and in /usr/share/X11/xkb/symbols/evdev:
>
> xkb/keycodes/evdev:     <I162> = 162;   // #define KEY_CYCLEWINDOWS        154
>
> Looks like KEY_CYCLEWINDOWS is already hooked up to
> gnome-settings-daemon to auto-rotate screen?

XF86RotateWindows is probably more "alt-tab" than "rotate screen".

> I ran into total dead end for finding a pre-existing example of home
> button usage.  I'm really surprised we do not yet have a KEY_LAUNCHER
> or similar because so many tablet PCs/smartphones/pads do have a
> button with this specific concept of "bring up your icon based
> application launcher".

KEY_LAUNCHER sounds like "Alt-F2" (that means krunner on KDE).
The advantage over KEY_HOMEPAGE is that it would work even when a
browser have the focus.

> - KEY_MENU
> - KEY_EXIT (smartphones sometime mean this)
> - KEY_PROG3 (basically all that Windows is doing)
> - KEY_LAUNCHER (why not be the first to finally create it!)
>
> I vote for either KEY_PROG3 or KEY_HOMEPAGE for at least short term.

So now, I vote (in order):
- KEY_LAUNCHER
- KEY_DASHBOARD
- KEY_PROG3

With this behavior (I'll use KEY_LAUCHER and KEY_PROG2)

- On press, do nothing
- On release, emit KEY_LAUNCHER if KEY_PROG2 wasn't emited
- On press, emit only one  KEY_PROG2 (I'd like to emit repeated
KEY_PROG2, but I understand that it makes things harder for
userspace).

-- 
Corentin Chary
http://xf.iksaif.net
