Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab0GAJQy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 05:16:54 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:51113 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754539Ab0GAJQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 05:16:52 -0400
Date: Thu, 01 Jul 2010 11:17:41 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCH/RFC 0/2] The Experimental Composite Gadget
To: linux-usb@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Message-id: <cover.1277972135.git.mina86@mina86.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.1
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The following two patches add an “Experimental Composite Gadget”
which is “Multifunction Composite Gadget” with FunctionFS and an
“Install Mode”.


An “Install Mode” is a mode where just after the device is connected
it reports as a mass storage device (single configuration, single
interface) with first logical unit being an removable CD-ROM.

The idea is that the logical unit provides a disk image with drivers
for the main device.  This way no additional data storage is needed
to make the device operational with hosts (i.e. no CD-ROM with
drivers needed).

When an eject is issued on the first logical unit the device switches
to a normal mode with all the other functionalities.  When device is
disconnected and connected again it switches back to the install
mode.


The switching is done by calling usb_composite_unregister() followed
by usb_composite_register().  The same approach is used in the
FunctionFS Gadget included in the kernel.

This is the main point I'd like to discuss.  What would be the best
way of switching device's configuration?

The best would be if it were possible to “reregister” the usb
composite device which would once again call the bind function.

Does that make sense?  Should I go and implement such a call to the
composite device?

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
