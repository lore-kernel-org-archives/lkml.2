Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397Ab1D0KaM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 06:30:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:23595 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751670Ab1D0KaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 06:30:10 -0400
Content-Type: multipart/mixed; boundary="===============1581831012=="
MIME-Version: 1.0
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,273,1301900400"; 
   d="scan'208";a="739084175"
From: Oren Weil <oren.jer.weil@intel.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        alan@linux.intel.com, david@woodhou.se,
        Oren Weil <oren.jer.weil@intel.com>
Subject: [PATCH 0/8] staging/mei: Intel MEI Driver
Date: Wed, 27 Apr 2011 13:27:29 +0300
Message-Id: <1303900057-21694-1-git-send-email-oren.jer.weil@intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--===============1581831012==
MIME-Version: 1.0

﻿Intel MEI Driver
=======================
The Intel Management Engine (Intel ME) is an isolated and 
protected computing resources (Coprocessor) residing inside 
Intel chipsets. The Intel ME provides support for computer/IT 
management features.
The Feature set depends on Intel chipset SKU. 

The Intel Management Engine Interface (Intel MEI, previous known 
as HECI) is interface between the Host and Intel ME. 
This interface is exposed to the host as PCI device. 
The Intel MEI Driver is in charge of the communication channel 
between host application and ME feature.

Each ME feature (ME Client) is addressed by GUID/UUID 
and each feature defines its own protocol. 
The protocol is message based with header and payload up to
512 bytes.

The driver exposes character device called /dev/mei.

Application maintain communication with a ME feature while 
/dev/mei is open. The feature binding is preformed by calling
MEI_CONNECT_CLIENT_IOCTL which pass the desired UUID.
The number of instances of a ME feature that can be opened 
at the same time depends on the ME feature, but most of the 
features allow only single instance

Intel AMT Host Interface (AMTHI) feature requires multiple 
user application maintaining therefore the MEI driver handle 
it internally by maintaining requests queues for it.

Because some of the ME features can change the system 
configuration, the driver by default allowing only privilege
user to access it.


pseudo code:
	struct mei_connect_client_data data;
	fd = open(MEI_DEVICE);

	data.d.in_client_uuid = AMTHI_UUID;

	ioctl(fd, IOCTL_MEI_CONNECT_CLIENT, &data);

	printf(“Ver=%d, MaxLen=%ld\n”, 
			data.d.in_client_uuid.protocol_version,
			data.d.in_client_uuid.max_msg_length);
	
	[...]
	
	write(fd, amthi_req_data, amthi_req_data_len);
	
	[...]
	
	read(fd, &amthi_res_data, amthi_res_data_len);
	
	[...]

Module Parameters
=================
watchdog_timeout - in order to change the watchdog timeout setting 
the user can use this module parameter.
this value set the Intel AMT watchdog timeout interval in seconds, 
the default value is 120sec.
to disable the watchdog set the value 0.

The AMT watchdog is used for monitoring the OS health. 

Note: We are aware that this code is not in its best shape
we are working to make it better and we will appreciate any feedbacks 
and reviews that you can give to improve it.


Oren Weil (8):
  staging/mei: PCI device and char driver support.
  staging/mei: Interrupt handling.
  staging/mei: MEI "Link" layer code - MEI Hardware communications.
  staging/mei: MEI driver init flow.
  staging/mei: Hardware and MEI driver internal struct definition
  staging/mei: Header file contain the Userland API, (IOCTL and its
    struct)
  staging/mei: AMT Watchdog
  staging/mei: Updates to staging/Kconfig ane staging/Makefile and a
    new Makefile and Kconfig

 drivers/staging/Kconfig           |    2 +
 drivers/staging/Makefile          |    1 +
 drivers/staging/mei/Kconfig       |   10 +
 drivers/staging/mei/Makefile      |   20 +
 drivers/staging/mei/hw.h          |  510 ++++++++++++
 drivers/staging/mei/init.c        |  769 +++++++++++++++++
 drivers/staging/mei/interface.c   |  440 ++++++++++
 drivers/staging/mei/interface.h   |  124 +++
 drivers/staging/mei/interrupt.c   | 1634 +++++++++++++++++++++++++++++++++++++
 drivers/staging/mei/iorw.c        |  595 ++++++++++++++
 drivers/staging/mei/main.c        | 1340 ++++++++++++++++++++++++++++++
 drivers/staging/mei/mei.h         |  148 ++++
 drivers/staging/mei/mei_version.h |   31 +
 drivers/staging/mei/wd.c          |  171 ++++
 include/linux/mei.h               |  105 +++
 15 files changed, 5900 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/mei/Kconfig
 create mode 100644 drivers/staging/mei/Makefile
 create mode 100644 drivers/staging/mei/hw.h
 create mode 100644 drivers/staging/mei/init.c
 create mode 100644 drivers/staging/mei/interface.c
 create mode 100644 drivers/staging/mei/interface.h
 create mode 100644 drivers/staging/mei/interrupt.c
 create mode 100644 drivers/staging/mei/iorw.c
 create mode 100644 drivers/staging/mei/main.c
 create mode 100644 drivers/staging/mei/mei.h
 create mode 100644 drivers/staging/mei/mei_version.h
 create mode 100644 drivers/staging/mei/wd.c
 create mode 100644 include/linux/mei.h


--===============1581831012==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

--===============1581831012==--
