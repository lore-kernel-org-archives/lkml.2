Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373Ab2FKVSt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 17:18:49 -0400
Received: from mailout-eu.gmx.com ([213.165.64.42]:42686 "HELO
	mailout-eu.gmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750854Ab2FKVSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 17:18:48 -0400
X-Authenticated: #50610217
X-Provags-ID: V01U2FsdGVkX196jSAojTB6wdDk8dneKAwDxVMsPtqvdds11WJqws
	tNQ461eg4T41KP
Date: Mon, 11 Jun 2012 23:18:42 +0200
From: Martin Nyhus <martin.nyhus@gmx.com>
To: Ben Skeggs <bskeggs@redhat.com>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [bisected] nouveau: "Failed to idle channel x" after resume
Message-ID: <20120611231842.221bd738@europa>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
after resuming from suspend nouveau starts writing Failed to idle
channel x (where x is 2 or 3) to the log and X appears to stop and then
restart only to stop again. Starting Firefox after resuming triggers the
bugs every time, and bisecting leads to 03bd6efa ("drm/nv50/fifo: use
hardware channel kickoff functionality").

$ grep -i nouveau .config
CONFIG_DRM_NOUVEAU=y
CONFIG_DRM_NOUVEAU_BACKLIGHT=y
# CONFIG_DRM_NOUVEAU_DEBUG is not set

Relevant part of the log (running v3.5-rc2-15-g4e3c8a1):
[   79.040710] PM: resume of devices complete after 1952.375 msecs
[   79.041735] PM: Finishing wakeup.
[   79.064052] Restarting tasks ... done.
[   79.064064] video LNXVIDEO:00: Restoring backlight state
[   79.645442] tg3 0000:09:00.0: irq 47 for MSI/MSI-X
[   79.707851] IPv6: ADDRCONF(NETDEV_UP): p3p1: link is not ready
[   81.288510] tg3 0000:09:00.0: p3p1: Link is up at 100 Mbps, full duplex
[   81.288510] tg3 0000:09:00.0: p3p1: Flow control is on for TX and on for RX
[   81.289824] IPv6: ADDRCONF(NETDEV_CHANGE): p3p1: link becomes ready
[  376.646417] [drm] nouveau 0000:01:00.0: PFIFO: channel 4 unload timeout
[  378.649010] [sched_delayed] sched: RT throttling activated
[  384.677024] [drm] nouveau 0000:01:00.0: Failed to idle channel 2.
[  384.678012] [drm] nouveau 0000:01:00.0: PFIFO: channel 2 unload timeout
[  389.685024] [drm] nouveau 0000:01:00.0: Failed to idle channel 3.
[  389.686012] [drm] nouveau 0000:01:00.0: PFIFO: channel 3 unload timeout
[  401.534024] [drm] nouveau 0000:01:00.0: Failed to idle channel 2.
[  401.535012] [drm] nouveau 0000:01:00.0: PFIFO: channel 2 unload timeout
...
[  456.688024] [drm] nouveau 0000:01:00.0: Failed to idle channel 3.
[  456.689013] [drm] nouveau 0000:01:00.0: PFIFO: channel 3 unload timeout
[  468.372025] [drm] nouveau 0000:01:00.0: Failed to idle channel 2.
[  468.373013] [drm] nouveau 0000:01:00.0: PFIFO: channel 2 unload timeout
