Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554Ab0EDGmx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 02:42:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54819 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756154Ab0EDGmu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 02:42:50 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] s2ram slow (radeon) / failing (usb)
Date: Tue, 4 May 2010 08:42:35 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc6-0.1-default; KDE/4.3.5; x86_64; ; )
Cc: Bruno =?utf-8?q?Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
       Jiri Kosina <jkosina@suse.cz>, USB@smtp1.linux-foundation.org,
       list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
References: <20100503214642.67577f91@neptune.home> <20100503225735.6b5e2687@neptune.home> <20100503231154.486c27d6@neptune.home>
In-Reply-To: <20100503231154.486c27d6@neptune.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201005040842.35260.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 3. Mai 2010 23:11:54 schrieb Bruno Prémont:
> [  477.543304] usb 1-2.1: usb_autosuspend_device: cnt 1 -> 0
> [  477.543316] usbhid 1-2.1:1.1: __pm_runtime_suspend()!
> [  477.543326] usbhid 1-2.1:1.1: __pm_runtime_suspend() returns 0!
> [  477.543380] usbcore: registered new interface driver usbhid
> [  477.549457] usbhid: USB HID core driver
> 
> And suspend is freezing inside of hid_cancel_delayed_stuff(usbhid) call
> from hid_suspend() in drivers/hid/usbhid/hid-core.c ...
> 
> Is it worth continuing iteration and adding further printk's down there?
> Jiri, what's your opinion on this?

Ugh. That looks like a bug in usbhid that I introduced. A fix is not trivial.
In short, I did not think the device could be undergoing a queued resumption
while suspend() is being called. I wonder why this is happening.

	Regards
		Oliver
