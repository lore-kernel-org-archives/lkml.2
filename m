Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab2D1Ped (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 11:34:33 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:56207 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627Ab2D1PeJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 11:34:09 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Steffen =?utf-8?q?M=C3=BCller?= <steffen.mueller@radio-frei.de>
Subject: Re: [opensuse-factory] Re: usb midi keyboard broken [3.3.3 regression] [SOLUTION]
Date: Sat, 28 Apr 2012 17:30:04 +0200
User-Agent: KMail/1.13.5 (Linux/3.3.0-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: opensuse-factory@opensuse.org, Alan Stern <stern@rowland.harvard.edu>,
        Jiri Slaby <jslaby@suse.cz>, stable@kernel.org,
        Greg KH <greg@kroah.com>, USB list <linux-usb@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.1204271122550.1690-100000@iolanthe.rowland.org> <14061824.J155VMHgKz@thinkpadsm.rf-studio>
In-Reply-To: <14061824.J155VMHgKz@thinkpadsm.rf-studio>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201204281730.04550.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 28. April 2012, 13:45:56 schrieb Steffen Müller:
> Oh man! After look and try many usr relevant settings I found the malfactor: 
> tlp usb autosuspend settings.
> 
> I use tlp (energy-saving tools for thinkpad laptops) and they autosuspend usb 
> devices by default. Now I have blacklisted my midi keyboard an all is good. I 
> can reproduce the problem this way. Seems so that the midi keyboard doesn't 
> wake up if it once sleeping.
> 
> For all with similar problems: 
> edit /etc/default/tlp and set USB_BLACKLIST="<device id from usbls>" or 
> disable usb autosuspend entirely with USB_AUTOSUSPEND=0
> 
> thanks and sorry for the bother.

No problem, but we ought to test whether we can make it work with a kernel
quirk. Can you please test whether it works with USB_QUIRK_RESET_RESUME
in drivers/usb/core/quirks.c ?

	Regards
		Oliver
