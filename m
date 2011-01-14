Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444Ab1ANIxT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 03:53:19 -0500
Received: from snt0-omc1-s1.snt0.hotmail.com ([65.55.90.12]:30633 "EHLO
	snt0-omc1-s1.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752865Ab1ANIxN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 03:53:13 -0500
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Jan 2011 03:53:13 EST
Message-ID: <SNT127-W201EC6FD0CA513A90A8731E6F30@phx.gbl>
X-Originating-IP: [78.23.101.71]
From: Nico <segfault2@hotmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [2.6.37] /dev/sr0 disappears
Date: Fri, 14 Jan 2011 09:47:03 +0100
Importance: Normal
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 14 Jan 2011 08:47:03.0701 (UTC) FILETIME=[9DC55450:01CBB3C7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org






Hi,

I'm having a somewhat strange problem on a freshly compiled 2.6.37 kernel. The problem is that whenever I boot my system with this kernel version, my SATA DVD writer disappears in the sense that udev does not seem to make a block device (/dev/sr0) in /dev. Messages from dmesg indicate that it detects my drive, but udev does not seem to want to make entries for it in /dev. My system isn't old at all (openSUSE 11.3) and my udev version is udev-157-3.1.x86_64. If I boot back to 2.6.36.3, all works fine so I'm not really sure where to look or which to blame (kernel or udev). Below is my "persistent-cd.rules" file of udev, which works on 2.6.36.x but not on 2.6.37. When I configured this .37 kernel, I did not mess around with the char/block options in the config and when I look at them, I do not find anything outstanding that should cause this behavior. Any pointers on where to look or how to fix this issue?

# DVD_RW_AD-7260S (pci-0000:00:11.0-scsi-1:0:0:0)
SUBSYSTEM=="block", ENV{ID_CDROM}=="?*", ENV{ID_PATH}=="pci-0000:00:11.0-scsi-1:0:0:0", SYMLINK+="cdrom", ENV{GENERATED}="1"
SUBSYSTEM=="block", ENV{ID_CDROM}=="?*", ENV{ID_PATH}=="pci-0000:00:11.0-scsi-1:0:0:0", SYMLINK+="cdrw", ENV{GENERATED}="1"
SUBSYSTEM=="block", ENV{ID_CDROM}=="?*", ENV{ID_PATH}=="pci-0000:00:11.0-scsi-1:0:0:0", SYMLINK+="dvd", ENV{GENERATED}="1"
SUBSYSTEM=="block", ENV{ID_CDROM}=="?*", ENV{ID_PATH}=="pci-0000:00:11.0-scsi-1:0:0:0", SYMLINK+="dvdrw", ENV{GENERATED}="1"

PS: please CC me as I'm not subscribed to the list
 		 	   		  