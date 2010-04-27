Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732Ab0D0NYF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 09:24:05 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:43811 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755518Ab0D0NX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 09:23:59 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: linux-pm@lists.linux-foundation.org
Subject: ehci_hcd causes immediate wakeup from suspend to RAM or disk on Asus P4P800-VM
Date: Tue, 27 Apr 2010 15:23:46 +0200
User-Agent: KMail/1.9.10
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201004271523.48647.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
machine with Asus P4P800-VM mainboard wakes up immediately after:
echo mem >/sys/power/state
or even
echo disk >/sys/power/state (only when /sys/power/disk is set to "platform", 
which is the default)

The problem disappears when unloading ehci_hcd module. There are no USB 
devices attached. The problem seems to be something like this:
http://www.mail-archive.com/linux-usb-devel%40lists.sourceforge.net/msg54499.html

/sys/devices/pci0000:00/0000:00:1d.7/power/wakeup is disabled by default

/sys/devices/pci0000:00/0000:00:1d.7/usb1/power/wakeup is enabled by default, 
changing it to disabled fixes the problem

The board has 4 USBPWxx jumpers (USBPW12, USBPW34, USBPW56 and USBPW78) that 
selects 5V or 5VSB as power to the corresponding USB connectors. When they're 
all set to 5VSB, the immediate wakeup does not appear. When any of them is 
set to 5V, it wakes up immediately after entering suspend. I guess that the 
loss of power to any of the ports (5V power is turned off in suspend) is 
detected as some event (overcurrent or device connect?)

"ignore_oc=1" parameter to ehci_hcd modules does not change anything.

-- 
Ondrej Zary
