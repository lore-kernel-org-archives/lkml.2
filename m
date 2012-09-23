Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805Ab2IWLDo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 07:03:44 -0400
Received: from orion.CARNet.hr ([161.53.160.90]:41611 "EHLO orion.carnet.hr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462Ab2IWLDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 07:03:42 -0400
X-Greylist: delayed 2418 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 Sep 2012 07:03:42 EDT
Date: Sun, 23 Sep 2012 12:23:18 +0200
From: Josip Rodin <joy@debbugs.entuzijast.net>
To: Nestor Lopez Casado <nlopezcasad@logitech.com>
Cc: Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        685360@bugs.debian.org, john.ettedgui@gmail.com, barz621@gmail.com,
        dh.herrmann@googlemail.com
Subject: Re: [PATCH 1/1] HID: Fix missing Unifying device issue
Message-ID: <20120923102318.GA12946@entuzijast.net>
References: <1348222894-6767-1-git-send-email-nlopezcasad@logitech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348222894-6767-1-git-send-email-nlopezcasad@logitech.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 12:21:34PM +0200, Nestor Lopez Casado wrote:
> This patch fixes an issue introduced after commit 4ea5454203d991ec
> 
> After that commit, hid-core silently discards any incoming packet
> that arrives while any hid driver's probe function is being executed.

I managed to test this now, on top of Linux 3.5, but it didn't fix my
keyboard. I still get the same sequence of messages with hid.debug=1:

+usb 5-2: new full-speed USB device number 3 using ohci_hcd
+drivers/hid/usbhid/hid-core.c: HID probe called for ifnum 0
+drivers/hid/hid-logitech-dj.c: logi_dj_probe called for ifnum 0
+drivers/hid/hid-logitech-dj.c: logi_dj_probe: ignoring ifnum 0
+drivers/hid/usbhid/hid-core.c: HID probe called for ifnum 1
+drivers/hid/hid-logitech-dj.c: logi_dj_probe called for ifnum 1
+drivers/hid/hid-logitech-dj.c: logi_dj_probe: ignoring ifnum 1
+drivers/hid/usbhid/hid-core.c: HID probe called for ifnum 2
+drivers/hid/hid-logitech-dj.c: logi_dj_probe called for ifnum 2
+drivers/hid/usbhid/hid-core.c: submitting ctrl urb: Get_Report wValue=0x0110 wIndex=0x0002 wLength=7
+drivers/hid/usbhid/hid-core.c: submitting ctrl urb: Get_Report wValue=0x0111 wIndex=0x0002 wLength=20
+drivers/hid/usbhid/hid-core.c: submitting ctrl urb: Get_Report wValue=0x0120 wIndex=0x0002 wLength=15
+drivers/hid/usbhid/hid-core.c: submitting ctrl urb: Get_Report wValue=0x0121 wIndex=0x0002 wLength=32
+logitech-djreceiver 0003:046D:C52B.0005: claimed by neither input, hiddev nor hidraw
+logitech-djreceiver 0003:046D:C52B.0005: logi_dj_probe:hid_hw_start returned error

-- 
     2. That which causes joy or happiness.
