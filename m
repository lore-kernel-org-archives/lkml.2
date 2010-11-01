Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985Ab0KABqg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 21:46:36 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55830 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614Ab0KABqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 21:46:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=oT5bx36MnHiejyNJzaxlyD7BEXWjkH1PakopKVtk0QYcG/Y0VvC6Vlle8I9RJODdbc
         F4u9fJgEAvZJpm54AJXLpBjaPPlj8DPI93B5WWL4ayUip4ey3NwgfmELQnLgHGdDcPn8
         IidpMXub6Uo1Wmt3e5+j86NV1s3GmquoWg5P8=
Message-ID: <4CCE1C11.6050807@lwfinger.net>
Date: Sun, 31 Oct 2010 20:46:57 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.14) Gecko/20101013 SUSE/3.0.9 Thunderbird/3.0.9
MIME-Version: 1.0
To: David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.36-gitX spams logs with "hub 4-0:1.0: unable to enumerate USB
 device on port 5" messages
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the current mainline pull (get describe shows v2.6.36-9871-g3985c7c), my
logs are spammed with

[  101.308220] hub 4-0:1.0: unable to enumerate USB device on port 5
[  101.548357] hub 2-0:1.0: unable to enumerate USB device on port 5
[  101.760094] hub 4-0:1.0: unable to enumerate USB device on port 5
[  102.000128] hub 2-0:1.0: unable to enumerate USB device on port 5
[  102.212187] hub 4-0:1.0: unable to enumerate USB device on port 5
[  102.452196] hub 2-0:1.0: unable to enumerate USB device on port 5
[  102.664131] hub 4-0:1.0: unable to enumerate USB device on port 5

The USB devices on my system are

finger@larrylap:~/wireless-testing> lsusb
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 001 Device 002: ID 0409:005a NEC Corp. HighSpeed Hub
Bus 001 Device 003: ID 04f2:b016 Chicony Electronics Co., Ltd VGA 30fps UVC Webcam
Bus 001 Device 004: ID 07d1:3300 D-Link System
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub

I had this problem in the past when ohci_hcd was being loaded before ehci_hcd,
but that is not the case now as is shown by lsmod:

mbcache                 7798  1 ext3
ohci_hcd               22322  0
sd_mod                 29184  4
ehci_hcd               37829  0
usbcore               158887  4 r8712u,ohci_hcd,ehci_hcd


Larry
