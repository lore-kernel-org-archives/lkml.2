Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750Ab1DDWfk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 18:35:40 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:33010
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752484Ab1DDWfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 18:35:39 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 00/22] Staging: hv: Cleanup storage drivers - Phase IV 
Date: Mon,  4 Apr 2011 15:46:26 -0700
Message-Id: <1301957186-7853-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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
