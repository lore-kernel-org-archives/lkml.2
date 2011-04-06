Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577Ab1DFWwN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 18:52:13 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:56869
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755397Ab1DFWwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 18:52:12 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [RESEND][PATCH 00/22] Staging: hv: Cleanup storage drivers - Phase IV 
Date: Wed,  6 Apr 2011 16:03:26 -0700
Message-Id: <1302131006-15411-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest upstream merge changed struct block_device_operations:
This merge got rid of blkvsc_media_changed and introduced the
function blkvsc_check_events. This broke all the patches that
were sent after the tree was closed the last time. This is a resend of
this patch-set to account for this change in the kernel.


More cleanup. In this patch-set we deal with the following issues:

	1) While a Linux guest on Hyper-V can be assigned removable media
	   devices (DVD, floppy etc), these devices are not handled by the
	   Hyper-V block driver. So, we cleanup all the dead code
	   dealing with removable media devices.

	2) There were multiple functions to retrieve information about 
	   the device. Since much of the code in these functions were
	   identical, we have consolidated these functions into a single
	   function.

	3) Enable the ioctl code for handling HDIO_GET_IDENTITY

	4) Cleanup the code for getting the geometry.

	5) Cleanup code for retreiving device capacity; this has also fixed
	   a bug with regards to presenting physical disks to the guest
	   as an IDE disk.

	6) General cleanup: simplify blkvsc_init_rw(), get rid of 
	   unnecessary DPRINT*() calls, get rid of unnecessary code,
	   cleanup blkvsc_open().

	7) Remove all IDE details from blkvsc_drv.c.

Regards,

K. Y
