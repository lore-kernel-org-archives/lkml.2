Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab1H2PXZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 11:23:25 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:54178 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010Ab1H2PXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 11:23:23 -0400
MIME-Version: 1.0
Date: Mon, 29 Aug 2011 17:23:22 +0200
Message-ID: <CAKr4yMzpqjfShWL9KDTW10CiXQpMWwmw82qB3BGCKKn6fOTq4w@mail.gmail.com>
Subject: staging: usbip: all I/O dies, how to debug?
From: Alexander Thomas <alexander.thomas@esaturnus.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am experimenting with the usbip project that is currently in the
staging drivers tree. I have a particularly nasty problem with it.

Everything works but at random moments all I/O will die system-wide.
In most cases this manifests itself as X11 freezing entirely with a
hardware reset as only way out. Sometimes certain programs like xclock
or top in a terminal will still show activity, but the machine will
not react to anything: no keyboard input, no ping, no ACPI shutdown.
In the logs there is nothing useful except sometimes a message of
(S)ATA being reset. When I'm at the console when it happens it will
show the same (S)ATA reset, attempts to remount the filesystem
read-only, and eventually it keeps repeating things like "Buffer I/O
error", "lost page write" and "unhandled error code
Result=DID_BAD_TARGET driverbyte=DRIVER_OK" every few dozen seconds.

After many experiments I have found that there is one condition that
must be met to trigger the crash: there must be simultaneous USB
traffic from the remote device and a local USB device (moving the
mouse will do). There are also a few other conditions that increase
the probability of it happening:
1. There is other heavy I/O traffic on the client, e.g. disk activity.
Compiling something is a good way to trigger the freeze.
2. The traffic from the remote device is incoming. Although I did
manage to get a crash while playing sound to a remote USB sound card,
it took way longer than when recording sound.

I have tested this with kernels ranging from 2.6.30 to 2.6.38 on two
different physical machines and inside a virtual machine. A possibly
important note is that I first had this exact same problem with a
commercial USB/IP product. I contacted the vendor but they say they
are unable to reproduce the problem. My disappointment was great when
I finally got the open source usbip working on older kernels only to
discover that it kills my system in the same way.

I have tried to debug in a virtual machine but this is problematic because:
a. it involves using a serial connection which also dies together with the rest
b. there is no way to predict when the crash will happen. This is one
of those annoying completely random bugs.
c. I have no experience in debugging at kernel/module level.

Is there anyone who can give pointers as to how to debug a problem
like this, and/or where to look for the cause?

Alexander
