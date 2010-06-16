Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758579Ab0FPKJn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 06:09:43 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:34491 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320Ab0FPKHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 06:07:23 -0400
Date: Wed, 16 Jun 2010 12:07:55 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv5 00/11] g_multi & other improvements and cleanpus
In-reply-to: <20100615185527.GA22803@kroah.com>
To: linux-usb@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>, Greg KH <greg@kroah.com>,
       Xiaofan Chen <xiaofanc@gmail.com>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Message-id: <cover.1276681840.git.m.nazarewicz@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.1
Content-type: TEXT/PLAIN; CHARSET=EUC-KR
Content-transfer-encoding: 8BIT
References: <20100615185527.GA22803@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jun 2010 20:55:27 +0200, Greg KH <greg@kroah.com> wrote:
> Can you resend this the 5th time so I know I have all of the proper
> versions?

As requested resending the whole patchset again.


Compared to the previous comments in RNDIS and CDC ACM INF files have
been updated (the RNDIS fix was previously sent as v4.1 but this
patchset includes a bit updated version) and a little fix to patch 01
has been applied (already sent as version v4.1).

The g_multi "more configuration" and install mode has been exluded
from this patches -- they weren't ment for inclusien in the kernel in
th elast patchset (just to show them), so no point in including here
(if aynone interested refer to v4 patches 10/13 and 13/13).


I wasn't sure 100% sure what wording to use in the CDC ACM INF file so
I put something that is likely to be true and safe. ;) I posted
on m.p.d.d.d and contactec Microchip so maybe there will be some more
info.


Michal Nazarewicz (11):
  USB: gadget: g_mass_storage: static data instead of dynamic
    allocation
  USB: gadget: f_mass_storage: fsg_add() renamed to fsg_bind_config()
  USB: gadget: f_fs: functionfs_add() renamed to
    functionfs_bind_config()
  USB: gadget: composite: usb_string_ids_*() functions added
  USB: gadget: f_fs: use usb_string_ids_n()
  USB: gadget: g_multi: code clean up and refactoring
  USB: gadget: g_ether: updated INF file
  USB: gadget: g_serial: INF file updated
  USB: gadget: g_multi: added documentation and INF files
  USB: gadget: composite: addad disconnect callback
  USB: gadget: f_mass_storage: added eject callback

 Documentation/usb/gadget_multi.txt  |  150 ++++++++++++++++++++
 Documentation/usb/gadget_serial.txt |   87 ++----------
 Documentation/usb/linux-cdc-acm.inf |  107 ++++++++++++++
 Documentation/usb/linux.inf         |  236 +++++++------------------------
 drivers/usb/gadget/Kconfig          |    1 +
 drivers/usb/gadget/composite.c      |   73 +++++++++-
 drivers/usb/gadget/f_fs.c           |   36 ++---
 drivers/usb/gadget/f_mass_storage.c |  122 +++++++++++------
 drivers/usb/gadget/g_ffs.c          |    2 +-
 drivers/usb/gadget/mass_storage.c   |   20 ++-
 drivers/usb/gadget/multi.c          |  262 ++++++++++++++++++++---------------
 include/linux/usb/composite.h       |    6 +
 include/linux/usb/functionfs.h      |    6 +-
 13 files changed, 654 insertions(+), 454 deletions(-)
 create mode 100644 Documentation/usb/gadget_multi.txt
 create mode 100644 Documentation/usb/linux-cdc-acm.inf

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
