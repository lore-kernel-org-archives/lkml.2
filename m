Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758326Ab0E1KCP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 06:02:15 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:65148 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261Ab0E1KCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 06:02:09 -0400
Date: Fri, 28 May 2010 12:02:25 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv2 0/7] Several improvements to USB gadgets
To: linux-usb@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Message-id: <cover.1275034701.git.mina86@mina86.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.1
Content-type: TEXT/PLAIN; CHARSET=EUC-KR
Content-transfer-encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

I'm resending my earlier patchsets with two changes.


First of all, there was a tiny coding style bug in one of the patches
(reported by Sergei Shtylyov).


Second of all, David has shown some concerns about overcomplicating
the g_multi driver by introducing several Kconfig options.  I assumed
he knows better and so excluded this particular patch from the set.

The other patch modifying the g_multi is however legitimate in my
opinion as it clears the code and fixes some section mismatch
warnings.


The whole patchset introduces several improvements to USB gadgets,
functions, etc.:


Michal Nazarewicz (7):
  USB: gadget: g_mass_storage: static data instead of dynamic
    allocation

A micro optimisation preventing a kmalloc call() which would otherwise
be always called at the very beginning for the same area size.

This was submitted previously but Greg did not included it in his
quilt tree (unless I overlooked something) so I'll posting it again
for completeness.  Sorry if that creates confusion.

In my opinion this is worth including as it simplifies the code a bit
and removes the call to kmalloc/kfree (hidden in fsg_common_init)
which in my opinion is a good thing as well.

Note, that the next patch won't apply without this one -- conflict is
trivial to solve though.


  USB: gadget: f_mass_storage: fsg_add() renamed to fsg_bind_config()
  USB: gadget: f_fs: functionfs_add() renamed to
    functionfs_bind_config()

All other functions use foo_bind_config() to add function to USB
configuration so changed the names for mass storage and FunctionFS as
well.

The inconstancy apparent in multifunction gadgets stroke me for quite
some time now.  I was always reluctant to submit patch thinking that
it would be just stupid name change but finally couldn't stand it. ;)

In case of mass storage the old (fsg_add()) function is still
available but marked deprecated.  In case of FFS the old
(functionfs_add()) function has been removed.


  USB: gadget: composite: usb_string_ids_*() functions added
  USB: gadget: f_fs: use usb_string_ids_n()

usb_string_ids_n() and usb_string_ids_tab() functions added for batch
sting IDs requests.

  USB: gadget: g_multi: code clean up and refactoring
  USB: gadget: g_multi: added documentation and INF files

g_multi clean up, fixes, etc.  Also, the last patch includes a bit of
documentation for g_multi and an INF file tested with Windows XP SP3.
Hopefully, someone will find it useful.


 Documentation/usb/gadget_multi.txt        |  160 ++++++++++++++++++
 Documentation/usb/gadget_multi_rndis.inf  |  200 ++++++++++++++++++++++
 Documentation/usb/gadget_multi_serial.inf |   44 +++++
 drivers/usb/gadget/Kconfig                |    1 +
 drivers/usb/gadget/composite.c            |   67 +++++++-
 drivers/usb/gadget/f_fs.c                 |   36 ++---
 drivers/usb/gadget/f_mass_storage.c       |   13 +-
 drivers/usb/gadget/g_ffs.c                |    2 +-
 drivers/usb/gadget/mass_storage.c         |   13 +-
 drivers/usb/gadget/multi.c                |  262 ++++++++++++++++-------------
 include/linux/usb/composite.h             |    4 +
 include/linux/usb/functionfs.h            |    6 +-
 12 files changed, 656 insertions(+), 152 deletions(-)
 create mode 100644 Documentation/usb/gadget_multi.txt
 create mode 100644 Documentation/usb/gadget_multi_rndis.inf
 create mode 100644 Documentation/usb/gadget_multi_serial.inf

--
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
