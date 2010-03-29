Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236Ab0C2Q66 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 12:58:58 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:47028 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754778Ab0C2Q6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 12:58:53 -0400
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: linux-kernel@vger.kernel.org
Cc: socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
       sameo@linux.intel.com
Subject: [PATCH 0/3] add support for Janz MODULbus devices
Date: Mon, 29 Mar 2010 09:58:49 -0700
Message-Id: <1269881932-3803-1-git-send-email-iws@ovro.caltech.edu>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Mon, 29 Mar 2010 09:58:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds support for the Janz CMOD-IO carrier board, as well
as the Janz VMOD-ICAN3 Intelligent CAN controller and the Janz VMOD-TTL
Digital IO controller. The CMOD-IO carrier board is a PCI to MODULbus
bridge, into which plug MODULbus daughterboards.  I only have access to two
types of daughtercards, the VMOD-ICAN3 and VMOD-TTL boards mentioned above.

The CAN driver has been tested under high loads. I am able to generate ~60%
bus utilization. With two VMOD-ICAN3 boards looped back to each other,
neither one loses any packets when only a single board is generating
packets at maximum speed. Once both boards start generating packets, one
board will sometimes loose arbitration, and cause some lost packets.

After much review from the last posting of the series, I believe that this
should be ready for mainline. Many thanks to everyone that helped!

RFCv4 -> RFCv5:
- removed some dev_dbg() statements
- change default MODULbus modules to "none"
- accept both "empty" and "" in the MODULbus modules parameter
- print an error message when no MODULbus modules are specified
- add sysfs support to get/set CAN bus termination
- fix error-active and error-passive state reporting
- add support for netlink bus-error messages
- fixed sparse warnings
- used mfd-core API for multifunction device probing

RFCv3 -> RFCv4:
- addressed many review comments
- switch to NAPI
- add TX flow control
- mark functions with __devinit and __devexit
- add sysfs readout of MODULbus number (hex switch)
- implement GPIO driver for VMOD-TTL

RFCv2 -> RFCv3:
- addressed many review comments
- correct CAN bus error handling
- use struct device to track subdevices
- use structures for register layout
- add lots of #defines for register values
- use better function prefixes

RFCv1 -> RFCv2:
- converted to a multi-driver model
- addressed many review comments
- added CAN bus error handling
- use a work function only instead of work + NAPI
- use SJA1000 bittiming calculation code

Thanks,
Ira
