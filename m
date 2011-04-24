Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757893Ab1DXXFT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 19:05:19 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:62246 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757805Ab1DXXFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 19:05:15 -0400
From: Martin <marogge@onlinehome.de>
To: "vger.kernel.org, " <linux-kernel@vger.kernel.org>
Subject: ehci_hcd 0000:00:1d.0: HC died; cleaning up
Date: Mon, 25 Apr 2011 01:05:13 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38.4-ck3; KDE/4.5.5; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104250105.13141.marogge@onlinehome.de>
X-Provags-ID: V02:K0:vEDYkWsejFiwVV74Llphzhrq9n2z+y8hCdFcoMX4zMu
 GQoMxR2WOPijGKryPf/ejHZFYebhnin/tD66nrsqBDDkJCDNo1
 S770zd87DLSHb2/fiHBIqNW3m/079nkRRSuw1A+MhzZ0DDLNl9
 9Sy6FCyUc+u+15bw2ICqAObgycAQVErIY0XDJMRPdDy/sjUHS+
 pt9r6kpVuX/yZJ4IEMIOg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

recently, when plugging in my webcam (UVC driver) my USB stack seems to 
collapse. All USB devices including the mouse & keyboard stop working, the 
syslog says:

Apr 24 19:03:45 arnold kernel: ehci_hcd 0000:00:1d.0: fatal error
Apr 24 19:03:45 arnold kernel: ehci_hcd 0000:00:1d.0: force halt; handshake 
ffffc90000052024 00004000 00004000 -> -110
Apr 24 19:03:45 arnold kernel: ehci_hcd 0000:00:1d.0: HC died; cleaning up
Apr 24 19:03:45 arnold kernel: usb 2-1.3: device descriptor read/all, error 
-108
Apr 24 19:03:45 arnold kernel: hub 2-1:1.0: cannot disable port 3 (err = -19)
Apr 24 19:03:45 arnold kernel: hub 2-1:1.0: cannot reset port 3 (err = -19)
Apr 24 19:03:45 arnold kernel: hub 2-1:1.0: cannot disable port 3 (err = -19)
Apr 24 19:03:45 arnold kernel: hub 2-1:1.0: cannot reset port 3 (err = -19)
Apr 24 19:03:45 arnold kernel: hub 2-1:1.0: cannot disable port 3 (err = -19)
Apr 24 19:03:45 arnold kernel: hub 2-1:1.0: cannot reset port 3 (err = -19)
Apr 24 19:03:45 arnold kernel: hub 2-1:1.0: cannot disable port 3 (err = -19)
Apr 24 19:03:45 arnold kernel: hub 2-1:1.0: unable to enumerate USB device on 
port 3
Apr 24 19:03:45 arnold kernel: hub 2-1:1.0: cannot disable port 3 (err = -19)

Cycling through run level 1 (which restarts udev etc.) doesn't help, only 
remedy I found is a reboot.

So far it is only the UVC webcam causing the problem. Memory sticks seem to 
work as expected.

I seem to remember it used to work previously and most likely one of my recent 
kernel upgrades is the trigger (currently on 2.6.38.4). However, before I 
delve into bisecting (the weather forecast for Easter Monday is too good): can 
someone tell what's going on from those error codes in the syslog?

Thanks,

Martin


