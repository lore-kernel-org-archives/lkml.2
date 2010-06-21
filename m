Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab0FUAV1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 20:21:27 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57287 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754797Ab0FUAVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 20:21:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=OFV+CQubvE/yLdyV7Jjwz3lAFCGXiRKe7/gwkYvqzuwBVg3mkZUJkn+GFYAqu5H7nT
         jrAUSK+fyTUVWXruICjS/zSolyhGYZu7Vm4DYsMuO2OKbHezWG/tKoXPyynBbBYd7NRb
         BA7WJVjqJ9f3dB+SjJb/ALdUdinaAiGS3lV+E=
MIME-Version: 1.0
Date: Sun, 20 Jun 2010 20:21:22 -0400
Message-ID: <AANLkTikeDoxm6OzWldU5PAr06wvW89asIIPNrpVKoc8I@mail.gmail.com>
Subject: Kernel does strange things when compilations push memory usage above 
	physical memory and the compilations are being done in a tmpfs, despite 
	having ample swap
From: Richard Yao <shiningarcanine@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Everyone,

My desktop has 4GB of RAM and it is running an unpatched Linux 2.6.34
kernel. I recently migrated it from Windows 7 to Gentoo Linux and I am
encountering a highly peculiar problem when I build/rebuild system
packages in a manner that stresses memory.

When system memory usage exceeds 4GB because I have several
compilations running simultaneously, all of which have had -j5 passed
to make, with the build scripts sharing an 8GB tmpfs directory, the
system typically responds by activating the kernel oom-killer, which
will usually kill some of the processes involved in the compilations,
among other things. This is with an 8GB swap partition and barely any
of it is touched when this happens according to KDE's system monitor.
Rarer, but alternative responses that the system has made to such
circumstances involve the system package manager failing
mid-compilation with "Segmentation fault" printed to the console or
open office failing with an obscure error message. Usually just
compiling open office alone is enough to have things fail, although I
usually see it fail with an obscure 5 digit error message that has no
meaning which I can derive from doing searches with Google. Unmounting
my tmpfs directory and doing things as I normally would do them makes
these issues disappear.

I have run memtest and it has not detected any hardware issues. I
tried asking for help on the Gentoo Linux forums, but I received no
responses and this looks like a kernel issue, so I thought it would be
a good idea to ask for assistance on the kernel mailing list. Here is
a link to a copy of my kernel's .config file:

http://paste.pocoo.org/show/227799/

As I was typing this, I had openoffice 3.2.1 and something else
compiling in the background and the system completely froze. This is
the first I have seen my system do this and it was about 10 minutes
after the oom-killer had already taken out kwin and several tabs in
chromium. I had SSH running in the background, but even that has been
rendered inaccessible by the freeze. I cannot get a response from the
system via arping and nmap is telling me that the system is down.

Earlier today, I tried to reproduce this issue under simpler
cirumstances by doing dd bs=4096 count=2097152 if=/dev/zero
of=/var/tmp/portage/zero.bak. As a consequence of all of the swapping
that occurred, the system's X server become unresponsive, so I walked
away and came back a few minutes later to find that the KDE System
Monitor had crashed, but everything else seemed fine.

Any help with this issue would be appreciated. I am willing to
recompile my system in whatever manner necessary to diagnose the cause
of this issue. Please CC me any responses made either directly or
indirectly in response to this message.

Yours truly,
Richard Yao
