Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758779Ab2EONPI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 09:15:08 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56895 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758090Ab2EONPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 09:15:06 -0400
Date: Tue, 15 May 2012 15:14:57 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        gustavo@padovan.org, johan.hedberg@gmail.com
Subject: 3.4.0-rc7 regression: bluetooth vs. s2ram
Message-ID: <20120515131453.GA1936@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

In 3.4-rc7, if I suspend while bnep0 over btusb is connected, then
resume, system dies with a backtrace. (Unfortunately, it is not
exactly easy to capture).

If I suspend without bnep0 active, resume works. 

(This has worked before, but "before" may mean 3.2 in this case).

Can someone test/reproduce this? Ideas?

									Pavel

PS: Under normal suspend/resume, I see these warnings in the
log. Maybe relevant?

ehci_hcd 0000:00:1d.7: GetStatus port:7 status 003002 0  ACK POWER OWNER sig=se0 CSC
usb 5-2: finish reset-resume
uhci_hcd 0000:00:1d.3: port 1 portsc 0093,00
usb 5-1: finish reset-resume
usb 5-2: reset full-speed USB device number 3 using uhci_hcd
usb 5-2: ep0 maxpacket = 8
usb 5-1: reset full-speed USB device number 2 using uhci_hcd
btusb 5-1:1.0: no reset_resume for driver btusb?
btusb 5-1:1.1: no reset_resume for driver btusb?
btusb 5-1:1.0: forced unbind
usb usb2: suspend_rh (auto-stop)
usb usb3: suspend_rh (auto-stop)
usb usb4: suspend_rh (auto-stop)
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
