Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605Ab1CGV7n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 16:59:43 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:40576
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756246Ab1CGV7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 16:59:42 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: kys@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Subject: [PATCH 00/16] Staging: hv: Consolidate driver and device abstractions 
Date: Mon,  7 Mar 2011 14:09:04 -0800
Message-Id: <1299535744-23047-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hyper-V has maintained both its class independent driver and 
device state in two independent data structures:
Driver state: struct driver_context (vmbus.h) and struct hv_driver
(vmbus_api.h)
Device state: struct vm_device (vmbus.h) and struct hv_device (vmbus_api.h)

While sruct driver_context and struct vm_device embed generic 
Linux abstractions of struct device_driver and struct device respectively; 
the lower level hyperv abstraction: struct hv_driver and struct hv_device
have maintained state needed to communicate with the host. This partitioning
made sense at a point in time when it was not clear how much of 
the hypervisor interaction would be open sourced. Given where we are
today, there is no reason to keep this layering. This patchset 
consolidates all the driver state into a single structure: 
struct hv_driver while all the device state is consolidated into
a single structure: struct hv_device. This consolidation simplifies
the code while simultaneously getting rid of redundant state -
for instance in the current code, both struct driver_context and
struct hv_driver both have state to represent the class as well as
instance id. We do this consolidation by moving state from higher
level structures (struct driver_context and struct vm_device) to
lower level structures (struct hv_driver and hv_device) respectively.

While it has not been a goal of this effort to cleanup structure and 
variable names, this consolidation effort has resulted in some cleanup
with regards to structure and variable names: a) Some of the badly
named structures have been eliminated (struct driver_context etc.) 
while hopefully all newly introduced names are acceptable.  

Patches 1 through 11 deal with consolidating the device driver
state while patches 12 through 16  deal with consolidating
device state.


Regards,

K. Y

