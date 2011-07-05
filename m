Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab1GEHLF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 03:11:05 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:45353 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664Ab1GEHLE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 03:11:04 -0400
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: 3.0rc3-rc5: usb stops working after resume from suspend to ram
Date: Tue, 5 Jul 2011 09:10:57 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.0-rc6-dirty; KDE/4.6.5; x86_64; ; )
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
References: <Pine.LNX.4.44L0.1107041155080.12242-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1107041155080.12242-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201107050910.57432.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 of July 2011, Alan Stern wrote:
> On Mon, 4 Jul 2011, Arkadiusz Miskiewicz wrote:
> > On Thursday 30 of June 2011, Alan Stern wrote:
> > > And now you know why, more or less -- we still have to figure out the
> > > reason for the hang.  Probably something goes wrong when cdc-ether is
> > > unbound from the wireless device.
> > 
> > Reverting patch below fixes hang.
> > 
> > commit fccf4e86200b8f5edd9a65da26f150e32ba79808
> > Author: Sarah Sharp <sarah.a.sharp@linux.intel.com>
> > Date:   Sun Jun 5 23:22:22 2011 -0700
> > 
> >     USB: Free bandwidth when usb_disable_device is called.
> 
> Ah, very good!  That explains everything.  Someone else reported a
> similar problem that was tracked down to this commit, and I submitted a
> fix a few days ago:
> 
> 	http://marc.info/?l=linux-usb&m=130955300211987&w=2
> 
> I bet this will fix your problem too.

Unfortunately it doesn't fix my problem (rc6 + that patch).

usb still hangs after resume and repluging device causes no effect.

[   60.530119] Restarting tasks ...
[   60.530179] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   60.530184] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   60.530188] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   60.530192] hub 8-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   60.530196] hub 2-0:1.0: state 7 ports 6 chg 0010 evt 0000
[   60.530205] hub 2-0:1.0: port 4, status 0100, change 0000, 12 Mb/s
[   60.530208] usb 2-4: USB disconnect, device number 2
[   60.530211] usb 2-4: unregistering device
[   60.530214] usb 2-4: unregistering interface 2-4:1.0
[   60.530265] usb 2-4: unregistering interface 2-4:1.1
[   60.540655] done.
[   60.540663] video LNXVIDEO:00: Restoring backlight state
[   60.544420] usb 2-4: unregistering interface 2-4:1.2
[   60.544478] usb 2-4: unregistering interface 2-4:1.3
[   60.544727] usb 2-4: unregistering interface 2-4:1.4
[   60.544834] usb 2-4: unregistering interface 2-4:1.5
[   60.544861] drivers/usb/core/file.c: removing 0 minor
[   60.544944] usb 2-4: unregistering interface 2-4:1.6
[   60.544973] drivers/usb/core/file.c: removing 1 minor
[   60.545073] usb 2-4: unregistering interface 2-4:1.7
[   60.545102] cdc_ether 2-4:1.7: wwan0: unregister 'cdc_ether' usb-0000:00:1d.7-4, Mobile Broadband Network Device


> Alan Stern


-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
