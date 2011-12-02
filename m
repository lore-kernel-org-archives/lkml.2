Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757007Ab1LBQo1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 11:44:27 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48896 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755724Ab1LBQo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 11:44:26 -0500
MIME-Version: 1.0
From: Jose Luis Salas <josacar@gmail.com>
Date: Fri, 2 Dec 2011 17:44:05 +0100
Message-ID: <CAJPugqsJgN9ZL3jQAZ+eGKfzxH0PAZonj-36H6PB1cHSpQHqSw@mail.gmail.com>
Subject: System freezes with high network activity
To: linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Nieder <jrnieder@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello there,

I' ve filled a bug against linux kernel in Debian [1] for the
linux-kernel-image 2.6.32.

The problem is that the system freezes ( no complete ) when high
network activity occurrs, for example copying files over NFS or
downloading files with Bittorrent.

When the system is frozen, there is no network connecivity, the
console freezes ( with top program, for ex. ) until a key from the
laptop is pressed or when network activity drops. The  network
throughtput also drops before the freeze.

I've also realized that clock drifts ( it's frozen too ) when the
system is frozen.

This problem didn't occur in Linux kernel 2.6.26 ( from the Lenny
release ), I think >2.6.26 are affected, but I need to confirm it ( >=
2.6.30 are included for sure ).

After investigating for a while (  tested noapic, noacpi and several
switches with no luck.) , I've search for a solution and I finally
found it.  I think that the bug is caused by changes in the
clocksource between kernels and the powernow-k8 module.

One time I tested booting the xen-patched the linux kernel and the
problem dissapeared, the net worked at full speed but there was no cpu
scaling.

Now, with recent kernels, I boot the kernel with the
clocksource=jiffies option and the powersaved daemon to do the
frequency scaling, the net works al full speed. With acpi_pm and tsc
options doesn't work neither.

More information as acpidump output and dmesg are included in the [1]
Debian bug too.

Thanks.

[1] http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=583363
