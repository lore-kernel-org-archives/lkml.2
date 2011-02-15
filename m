Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab1BOBna (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 20:43:30 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:50181 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752557Ab1BOBn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 20:43:28 -0500
From: Ram Pai <linuxram@us.ibm.com>
To: linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org
Cc: Ram Pai <linuxram@us.ibm.com>, linux-kernel@vger.kernel.org,
        clemens@ladisch.de, Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: [PATCH 0/4] PCI: preallocate resource patch series
Date: Mon, 14 Feb 2011 17:43:16 -0800
Message-Id: <1297734200-23327-1-git-send-email-linuxram@us.ibm.com>
X-Mailer: git-send-email 1.7.0.4
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    Linux tries to pre-allocate minimal resources to hotplug bridges. This
    works fine as long as there are enough resources  to satisfy all other
    genuine resource requirements. However if enough resources are not
    available to satisfy any of these nice-to-have pre-allocations, the
    resource-allocator reports errors and returns failure.

    This patch distinguishes between must-have resource from nice-to-have
    resource.  Any failure to allocate nice-to-have resources are ignored.

    This behavior can be particularly useful to trigger automatic
    reallocation when the OS discovers genuine allocation-conflicts
    or genuine unallocated-requests caused by buggy allocation behavior
    of the native BIOS/uEFI.

    https://bugzilla.kernel.org/show_bug.cgi?id=15960 captures the movitation
    behind the patch. This patch is verified to resolve the above bug.

    The first 3 patches refactors common code and builds the ground work
    for the 4 patch which contains the core piece of the fix.

    patch 1/4: refactors the io size calculation logic
    patch 2/4: refactors the list freeing logic
    patch 3/4: refactors the resource reset logic
    patch 4/4: contains the fix to the original problem

    drivers/pci/setup-bus.c   |  269 ++++++++++++++++++++++++++++++++++------------

    Signed-off-by: Ram Pai <linuxram@us.ibm.com>
