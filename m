Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630Ab2BLRox (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 12:44:53 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:54456 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754677Ab2BLRov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 12:44:51 -0500
MIME-Version: 1.0
In-Reply-To: <CAH=dYrE9EOudkk0mYwFpjgMM-kJ9bwFoDDJFrcWPwRG9NJM-uA@mail.gmail.com>
References: <CAH=dYrHhttmRjkVuo9QvJ5_Uqd+BJGCJJkaMw8153RW1SFv9dA@mail.gmail.com>
	<4F2316C7.9030202@canonical.com>
	<CAH=dYrF-71hTkxS1qpohT_Ja_XKEVwMyVT5ZXg2FZjK4c2Fyig@mail.gmail.com>
	<CAH=dYrE9EOudkk0mYwFpjgMM-kJ9bwFoDDJFrcWPwRG9NJM-uA@mail.gmail.com>
Date: Sun, 12 Feb 2012 12:44:50 -0500
Message-ID: <CAH=dYrFs+Ty2XxWvv6y-OMi6stT-tYR7nL20+2fyQLV3RgseKQ@mail.gmail.com>
Subject: Re: firmware loading failure for AR3011 (0cf3:3000 or 0cf3:3005 ?)
From: Andres Cimmarusti <acimmarusti@gmail.com>
To: "James M. Leddy" <james.leddy@canonical.com>
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Nieder <jrnieder@gmail.com>, 641749@bugs.debian.org,
        info@linuxcertified.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I believe I have finally narrowed down the problem. It lies in the
'libmtp-runtime' package with the command 'mtp-probe' (only present in
wheezy or newer).

I'm not sure what this is doing to my system, but when the package
mentioned is installed, it "messes" up my atheros bluetooth device so
that the kernel/udev cannot load the firmware into it.

As soon as I uninstalled this package and thus caused the boot process
to throw some errors about missing mtp-probe command, my bluetooth
module was correctly loaded and the led turned on.

>> Inexplicably yesterday's (and the day before) Debian testing snapshot
>> seems to have the problem fixed!

I guess this snapshot that I tested earlier didn't have that package installed

I found out about this completely by chance. For whatever reason, on
my second upgrade to wheezy 'apt-get dist-upgrade' didn't pull
'libmtp-runtime' and my bluetooth module just worked.

I tried to get the bootlog messages so I can send this info, but even
with bootlogd enabled these messages happen too early on the boot
process to be logged in /var/log/boot.

I feel this is not necessarily a kernel bug anymore (all kernels
tested work fine 3.0.x, 3.1.x, 3.2.x and even 3.3.0-rc3). But the
experts will know better.

This is definitely progress!

Cheers

Andres

PS: please forward the info to other bug reports I don't have access
to, like Red Hat / Fedora and Ubuntu. Additional testing is needed.
