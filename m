Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757060Ab0EBPHe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 11:07:34 -0400
Received: from netrider.rowland.org ([192.131.102.5]:38845 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756853Ab0EBPHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 11:07:31 -0400
Date: Sun, 2 May 2010 11:07:31 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
cc: dri-devel@lists.freedesktop.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: s2ram slow (radeon) / failing (usb)
In-Reply-To: <20100502155653.68fc3643@neptune.home>
Message-ID: <Pine.LNX.4.44L0.1005021102340.25185-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 May 2010, Bruno [UTF-8] Prémont wrote:

> Hi,
> 
> On a IEI Kino 690S1 I'm having a hard time to get s2ram running.
> It freezes during device suspend (unless I rmmod everything USB
> related) - usb fails even in pm_test case 'devices'.
> 
> When the system is able to suspend it takes an eternity (more than 3
> minutes to wake-up, the radeon apparently being responsible for quite
> a big share of that slowness.
> 
> 
> During resume early it looks like every PCI access needs about a second,
> and there are a few cases where during lots of seconds nothing seems to
> happen and the first event following is related to radeon.
> 
> The kernel used is todays Linus's tree at commit be1066bbcd443a65df312fdecea7e4959adedb45
> with Dave's drm-linus and drm-radeon-testing applied on top.
> 
> Note, I've not been able to suspend to RAM properly recently (last one
> that worked correctly but resumed without graphics was some-when during
> 2.6.2x, before KMS)
> Since then the system would either fail suspend or resume.
> 
> Manual changes I applied in order to find out some context information:
> - add a few debugging printk's to ata/ahci as that was the last entry
>   on serial console for freezing suspends (that one succeeded but
>   following step never completed, from suspend_prepare that would have
>   been USB => unload usb before suspend)
> - strip "if EMBEDED" from CONFIG_SERIAL_8250_PNP and disabled it so serial
>   console would continue working as long as possible and output suspend
>   progress (resume output happens only very late)
> 
> Is there some additional information I could gather in order do help
> improving s2ram on this system?
> - get it to suspend with usb loaded (ohci + ehci)
> - get it to resume a reasonable speed

There's no way to fix the USB problem without knowing what goes wrong.  
Let's see how far you get before the system freezes on a kernel with 
CONFIG_USB_DEBUG enabled.

Alan Stern

