Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757521Ab2HIQnb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 12:43:31 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:56024 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab2HIQn3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 12:43:29 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-pm@lists.linux-foundation.org
Subject: [REGRESSION] hard lockup on resume from suspend on ThinkPad T23
Date: Thu, 9 Aug 2012 18:43:28 +0200
User-Agent: KMail/1.13.7 (Linux/3.5.0-tp520; KDE/4.8.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201208091843.28342.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

I thought I report it here – although unless it rings a bell I won´t 
probably be doing much about it like a git-bisect since that machine is 
slow and it could take ages…

With Debian kernel 3.3.0-trunk-686-pae the machine suspends and resume for 
lots of times for 30-40 days uptime and more if I let it.

With Debian kernel 3.4-trunk-686-pae as well as 3.5-trunk-686-pae tried 
out today often not always the kernel locks up hard after resume. That is, 
the image is read back but then when switching to graphics or shortly 
afterwards the mouse pointer is frozen and the machine does not respond to 
ping anymore.

Graphics is ancient:

deepdance:~> lspci -nn | grep VGA
01:00.0 VGA compatible controller [0300]: S3 Inc. SuperSavage IX/C SDR 
[5333:8c2e] (rev 05)

CPU is Mobile Intel(R) Pentium(R) III CPU - M  1133MHz, the machine has 
768 MiB of RAM.

Filesystems are (aged) BTRFS (which contributes to the extreme slowness of 
the machine it seems – apt-get (dist-)upgrade without eatmydata takes 
long).

Kernel parameters are:

linux /vmlinuz-3.3.0-trunk-686-pae root=/dev/mapper/deepdance-debian ro 
vga=791 threadirqs init=/bin/systemd resume=/dev/mapper/deepdance-swap


I didn´t report this with 3.4 cause I hoped that difficult to debug bug 
would just go away with 3.5, but it seems it didn´t. If it could just dump 
out something useful before it crashes… I am using threadirqs since quite 
some time on various machines, but I could try disabling it if it seems to 
be suspicious.

I am back on 3.3 right now. It doesn´t matter that much on this machine.


Unless any brilliant ideas I might just keep it at this report. Maybe it 
rings a bell for someone who has a suggestion to try out.

I have 3.4 on ThinkPad T42 with some radeon chip and 3.4 and since some 
while 3.5 on ThinkPad T520 with Intel Sandybridge graphics – no issues 
there. So it only seems to affect this machine. T520 uses threadirqs, I 
think the T42 as well.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
