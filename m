Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395Ab1CWRio (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 13:38:44 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:45882
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752378Ab1CWRin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 13:38:43 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 00/16] Staging: hv: Cleanup storage drivers - Phase I 
Date: Wed, 23 Mar 2011 10:48:57 -0700
Message-Id: <1300902537-1290-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is first in a series of patch-sets aimed at cleaning up the storage
drivers for Hyper-V. Before I get into the details of this patch-set, I think
it is  useful to give a brief overview of the storage related front-end
drivers currently in the tree for Linux on Hyper-V:

On the host side, Windows emulates the  standard PC hardware 
to permit hosting of fully virtualized operating systems.
To enhance disk I/O performance, we support a virtual block driver.
This block driver currently handles disks that have been setup as IDE 
disks for the guest - as specified in the guest configuration.

On the SCSI side, we emulate a SCSI HBA. Devices configured
under the SCSI controller for the guest are handled via this
emulated HBA (SCSI front-end). So, SCSI disks configured for 
the guest are handled through native SCSI upper-level drivers.
If this SCSI front-end driver is not loaded, currently, the guest
cannot see devices that have been configured as SCSI devices. 
So, while the virtual block driver described earlier could potentially
handle all block devices, the implementation choices made on the host
may not permit it. Also, the only SCSI device that can be currently
configured for the guest is a disk device.

Both the block device driver (hv_blkvsc) and the SCSI front-end
driver (hv_storvsc) communicate with the host via unique channels
that are implemented as bi-directional ring-buffers. Each 
(storage) channel carries with it enough state to uniquely
identify the device on the host side. Microsoft has chosen to
use SCSI verbs for this storage channel communication.

In this patch-set I have addressed the following issues in the Hyper-V
storage drivers (virtual block and SCSI front-end):

	1) Get rid of the inclusion of storvsc.c from blockvsc.c
	2) Cleanup storvsc.c
	3) Get rid of the file blkvsc.c
	4) Cleanup the initialization sequence for both block and 
	   SCSI front-end drivers.

Regards,

K. Y
