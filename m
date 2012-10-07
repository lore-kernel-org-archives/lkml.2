Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519Ab2JGSn6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 14:43:58 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:56675 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473Ab2JGSnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 14:43:17 -0400
MIME-Version: 1.0
Date: Mon, 8 Oct 2012 00:43:16 +0600
Message-ID: <CACx33gg6Hmh8E0Mv5TLdi5ufZcppHMws8XAdfaThF_Y2QBb5vA@mail.gmail.com>
Subject: boot failure on i7-3317u in Samsung 900x3c
From: Mike Bakhterev <mike.bakhterev@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings.

When i'm trying to boot the subject maching in UEFI mode i get
sometimes machine check exception 0xbe2000000003110a (i was not able
to decode this, as some bits are not covered in Intel's Manuals). It
emerges when i am booting 3.4.x, 3.5.4 and 3.5.5 kernels from
ArchLinux. When i am booting from SSD i get this error all the time,
when i'm booting from USB stick i get this sometimes (quite frequently
and the probability to boot succesfully is increased when i specify
"verbose" kernel option). I'm booting with systemd. The sytems boots
always successfully, when i use the installation ArchLinux image,
which is shipped with 3.5 kernel and boots in BIOS mode with
traditional initscripts.

It looks like race condition when configuring memory or something like this.

It is not hardware error, because Windows 7 and 8 boot and run fine.
And this is my second unit, because the first one was broken
(something with motherboard) when running Windows 8, and Linux on that
broken machine reported the same MCE. Now Windows works OK (if you
could say, it works), and Linux reports the same MCEs.

Here is some guy playing with caching of PCI memory region and getting
the same MCE on the Sandy Bridge:
http://stackoverflow.com/questions/11254023/how-to-do-mmap-for-cacheable-pcie-bar

Sorry, but i have no time to bisect this :(

P.S. Excuse me my English.

P.P.S. Can this be fixed with kernel command line options?
