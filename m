Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab0FUT0D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 15:26:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34739 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753046Ab0FUTZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 15:25:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tino Keitel <tino.keitel+xorg@tikei.de>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Suspend hangs since 2.6.34
Date: Mon, 21 Jun 2010 21:24:08 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3-rjw+; KDE/4.4.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
References: <20100609175356.GA17332@x61.home> <201006100142.13131.rjw@sisk.pl> <20100620225601.GA15589@x61.home>
In-Reply-To: <20100620225601.GA15589@x61.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201006212124.09076.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 21, 2010, Tino Keitel wrote:
> Hi,
> 
> this nasty bug did not appear after I enabled suspend debugging first,
> but now it did:
> 
> 2010-06-20_22:40:31.22927 kern.info: usbcore: deregistering interface driver dvb_usb_vp7045
> 2010-06-20_22:40:31.24960 kern.debug: usb 1-6: __pm_runtime_resume()!
> 2010-06-20_22:40:31.24968 kern.debug: usb 1-6: __pm_runtime_resume() returns 1!
> 2010-06-20_22:40:31.24969 kern.debug: PM: Removing info for No Bus:dvb0.frontend0
> 2010-06-20_22:40:31.24971 kern.debug: PM: Removing info for No Bus:dvb0.net0
> 2010-06-20_22:40:31.24972 kern.debug: PM: Removing info for No Bus:dvb0.demux0
> 2010-06-20_22:40:31.24973 kern.debug: PM: Removing info for No Bus:dvb0.dvr0
> 2010-06-20_22:40:31.24974 kern.info: dvb-usb: Twinhan USB2.0 DVB-T receiver (TwinhanDTV Alpha/MagicBox II) successfully deinitialized and disconnected.
> 2010-06-20_22:40:32.26675 kern.info: PM: Syncing filesystems ... done.
> 2010-06-20_22:40:32.39011 kern.debug: PM: Preparing system for mem sleep
> 
> When I killed the suspend script which hung at the echo mem >
> /sys/power/state line, the computer suspended. After wakeup, the kernel
>  log lines after the line above look like this:
> 
> 2010-06-20_22:49:10.28745 kern.warn: Freezing user space processes ... (elapsed 0.02 seconds) done.
> 2010-06-20_22:49:10.28748 kern.warn: Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
> 2010-06-20_22:49:10.28748 kern.debug: PM: Entering mem sleep
> 2010-06-20_22:49:10.28749 kern.warn: Suspending console(s) (use no_console_suspend to debug)
> 
> I also attached the full kernel log since the boot.

Hmm.  It looks like a USB problem, then.

Alan, can you have a look at this, please?

Rafael
