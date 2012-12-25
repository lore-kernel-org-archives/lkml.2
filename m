Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab2LYDCR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 22:02:17 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:41001 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385Ab2LYDCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 22:02:14 -0500
Message-ID: <50D91733.2040000@gmail.com>
Date: Mon, 24 Dec 2012 22:02:11 -0500
From: Logan Rathbone <loganrathbone@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: USB 2.0 (EHCI) keeps crapping out (3.2.29)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

*** NOTE:  Kindly CC me directly if you reply to list since I'm not an 
LKML subscriber. ***

Running vanilla 3.2.29 (Slackware 14.0).  I also had this issue on 
2.6.37.6 and *possibly* 2.6.33.x, but I don't recall.

Every now and again (could be every few days, could take a couple of 
weeks... depends.) USB 2.0 stops working.  My scanner as well as certain 
mass-storage devices that are USB-2.0 compatible fail to function all of 
a sudden.

With the said mass storage devices, I get lots of errors like this in my 
logs:

hub 1-0:1.0: unable to enumerate USB device on port 3

Devices that have previously been mounted and accessed successfully 
begin giving input/output errors when I try to ls them.

rmmod'ing ehci_hcd and modprobe'ing it again resolves the issue until it 
occurs again.

It *could* be a hardware problem, but it seems odd that unloading & 
reloading the module instantly makes it work perfectly again.

Via USB 1.1/2.0 controller from circa 2002-2003.

If anyone has any ideas, please let me know...

logan@logancomp:~$ /sbin/lspci |grep -i usb
00:10.0 USB controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 
Controller (rev 80)
00:10.1 USB controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 
Controller (rev 80)
00:10.2 USB controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 
Controller (rev 80)
00:10.3 USB controller: VIA Technologies, Inc. USB 2.0 (rev 82)

logan@logancomp:~$ cat /proc/cmdline
auto BOOT_IMAGE=Slackware ro root=802 nohz=off highres=off 
clocksource=jiffies acpi_enforce_resources=lax vt.default_utf8=0
