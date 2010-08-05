Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760151Ab0HEK2G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 06:28:06 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:25617 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758642Ab0HEK0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 06:26:20 -0400
Date: Thu, 05 Aug 2010 12:27:34 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv6 0/7] Several USB fixes
To: Greg KH <greg@kroah.com>, David Brownell <david-b@pacbell.net>,
        USB <linux-usb@vger.kernel.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Message-id: <cover.1281002833.git.m.nazarewicz@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.1
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello again,

Michal Nazarewicz (7):

  USB: gadget: storage_common: fixed warning building mass storage
    function

    This fixes a warning in the storage_common.c file.

  USB: gadget: g_multi: fixed vendor and product ID
  USB: gadget: g_ffs: fixed vendor and product ID

    Those fix the product and vendor IDs of the g_multi and g_ffs
    gadgets.

Greg, could you pull the above three patches regardless of the status
of next four.  The first one was already sent and no one seemed to
have any troubles with it.  The second and the third are trivial
fixes.

  USB: gadget: composite: Better string override handling

    This fixes the string override in the composite framework.

David, could you look at it again and point out where exactly does it
use an unmanaged serial number, please?  I still don't see it...

  USB: gadget: mass_storage: moved strings handling code to composite
  USB: gadget: functionfs: code cleanup
  USB: gadget: g_multi: moved strings handling code to composite

    Those change g_mass_storage, g_ffs and g_multi to use new
    functionality of the composite layer.  In previous patchset I sent
    it as a single patch, splatted it as per David's request.

 drivers/usb/gadget/composite.c      |   95 +++++++++++++++++++++++------------
 drivers/usb/gadget/g_ffs.c          |   85 ++++++++++---------------------
 drivers/usb/gadget/mass_storage.c   |   72 ++------------------------
 drivers/usb/gadget/multi.c          |   23 ++-------
 drivers/usb/gadget/storage_common.c |   10 ++--
 include/linux/usb/composite.h       |   13 +++++
 6 files changed, 120 insertions(+), 178 deletions(-)

