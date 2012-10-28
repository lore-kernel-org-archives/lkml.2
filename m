Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429Ab2J1UqA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 16:46:00 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:48503 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323Ab2J1Up7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 16:45:59 -0400
Message-ID: <508D99F1.9080406@Gmail.com>
Date: Sun, 28 Oct 2012 15:47:45 -0500
From: Calvin Owens <jcalvinowens@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.9) Gecko/20121028 Thunderbird/10.0.9
MIME-Version: 1.0
To: David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>,
        Martin Peres <martin.peres@labri.fr>
CC: Calvin Owens <jcalvinowens@gmail.com>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [Bisected] nouveau: v3.7-rc breaks multi-monitor setup
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I have a somewhat unusual setup with 3 monitors, two connected to an
NVIDIA GT9800, and one connected to the onboard graphics card (a Radeon
HD4250, which is selected as the primary card in the BIOS). This has
worked well for quite some time using nouveau, but the 3.7 merge window
changes cause the two monitors attached to the NV card to appear blank.

The interesting thing is that X doesn't seem to even notice the
difference under 3.7-rc: the screens are blank, but it reports no errors
at all. Even the driver itself seems to happily go along writing to it's
framebuffer (see log below).

Also, the NV card *does* still work when I turn off the onboard gpu
(by setting the NV card as the primary (The BIOS masks the onboard
gpu in this case, so the 3-monitor configuration doesn't work)).

It would seem as though there is some important initialization step that
the BIOS does that nouveau used to do too, but isn't doing anymore.
(Usually when kernel modesetting happens (or when the BIOS comes up if
it's the primary card), the fan on the card quiets down, but now it just
stays in blow-dryer mode.)

Here is a nouveau debug loglevel "spam" bootup under 3.7-rc2+:
	* http://pastebin.com/Fysifmta
(It was 180k lines long - I tried to condense it by cutting out large
blocks of the same message)

I've bisected this to 77145f1 (which appears to be the last commit in a
big restructuring of the nouveau source tree). Unfortunately, the 40
commits before that one cause build errors, so narrowing it down will be
more time-consuming...

Other possibly relevant info:
lspci:		http://pastebin.com/6yjUv5du
Kconfig:	http://pastebin.com/eUPpNyJZ

Information from "git-bisect":
git output:	http://pastebin.com/DMRSr5AA
git bisect log: http://pastebin.com/d8MRXRAC
(77145f1 is the earliest build-able commit that causes the regression)

Let me know if there's anything I can do to help, or any more info that
would be useful to you.

Cheers,
Calvin Owens
