Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803Ab0ESJFz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 05:05:55 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:61095 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756097Ab0ESJEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 05:04:04 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: TEXT/PLAIN; CHARSET=EUC-KR
Date: Wed, 19 May 2010 11:04:14 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCH 0/8] Several improvements to USB gadgets
To: linux-usb@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Message-id: <cover.1274187425.git.m.nazarewicz@samsung.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset introduces several improvements to USB gadget,
functions, etc.:

Michal Nazarewicz (8):
  USB: gadget: g_mass_storage: static data instead of dynamic
    allocation

A micro optimisation preventing a kmalloc call() which would otherwise
be always called at the very beginning for the same area size.

This was submitted previously by me but Greg did not included it in
his quilt tree (unless I overlooked something) so I'll posting it
again for completeness.  Sorry if that creates confusion.

  USB: gadget: f_mass_storage: fsg_add() renamed to fsg_bind_config()
  USB: gadget: f_fs: functionfs_add() renamed to
    functionfs_bind_config()

All other functions use foo_bind_config() to add function to USB
configuration so changed the names for mass storage and FunctionFS as
well.

In case of mass storage the old (fsg_add()) function is still
available but marked deprecated.  In case of FFS the old
(functionfs_add()) function has been removed.

  USB: gadget: composite: usb_string_ids_*() functions added
  USB: gadget: f_fs: use usb_string_ids_n()

usb_string_ids_n() and usb_string_ids_tab() functions added for batch
sting IDs requests.

  USB: gadget: g_multi: code clean up and refactoring
  USB: gadget: g_multi: more configurable
  USB: gadget: g_multi: added documentation and INF files

g_multi clean up, fixes, etc.

 Documentation/usb/gadget_multi.txt        |  129 +++++++++++++++
 Documentation/usb/gadget_multi_rndis.inf  |  200 +++++++++++++++++++++++
 Documentation/usb/gadget_multi_serial.inf |   44 +++++
 drivers/usb/gadget/Kconfig                |   66 +++++---
 drivers/usb/gadget/composite.c            |   67 +++++++-
 drivers/usb/gadget/f_fs.c                 |   35 ++---
 drivers/usb/gadget/f_mass_storage.c       |   13 +-
 drivers/usb/gadget/g_ffs.c                |    2 +-
 drivers/usb/gadget/mass_storage.c         |   13 +-
 drivers/usb/gadget/multi.c                |  254 +++++++++++++++--------------
 include/linux/usb/composite.h             |    4 +
 include/linux/usb/functionfs.h            |    6 +-
 12 files changed, 653 insertions(+), 180 deletions(-)
 create mode 100644 Documentation/usb/gadget_multi.txt
 create mode 100644 Documentation/usb/gadget_multi_rndis.inf
 create mode 100644 Documentation/usb/gadget_multi_serial.inf

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
