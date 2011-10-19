Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047Ab1JSCyk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 22:54:40 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:58574 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955Ab1JSCyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 22:54:39 -0400
From: pingfank@linux.vnet.ibm.com
To: linux-kernel@vger.kernel.org, seabios@seabios.org, lenb@kernel.org,
        shaohua.li@intel.com
Cc: qemu-devel@nongnu.org, aliguori@us.ibm.com, dave@linux.vnet.ibm.com,
        Liu Ping Fan <pingfank@linux.vnet.ibm.com>
Subject: [PATCH 0/1] ACPI: Call ACPI remove handler when handling ACPI eject
Date: Wed, 19 Oct 2011 10:53:40 +0800
Message-Id: <1318992821-10552-1-git-send-email-pingfank@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.4.4
x-cbid: 11101902-2674-0000-0000-000000E55AA8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Ping Fan <pingfank@linux.vnet.ibm.com>

When I tried to enable cpu hotplug feature for qemu-kvm, I found that the ACPI device eject event just skipped by kernel.

static void acpi_bus_notify(acpi_handle handle, u32 type, void *data)
{ 
 	case ACPI_NOTIFY_EJECT_REQUEST:
		/* TBD */---> skipped from here
}

But I notice, in drivers/acpi/dock.c, dock_notify()->handle_eject_request() will handle such event for ACPI _dock device.
So what we shall do, changing Qemu's SeaBIOS or changing the kernel?  If changing SeaBIOS, will it affect guest MS-Window?



Thanks,
ping fan

