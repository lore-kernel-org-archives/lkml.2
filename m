Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046Ab2JGXjS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:39:18 -0400
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:58627
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754144Ab2JGXjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:39:16 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        akpm@linux-foundation.org, andi@firstfloor.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 0/2] Drivers: hv 
Date: Sun,  7 Oct 2012 16:59:07 -0700
Message-Id: <1349654347-18337-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a basic balloon driver to take advantage of the dynamic memory
management functionality supported on Windows hosts. Windows requires
the guests to support both memory hot add as well as ballooning. In this patch
we are adding the basic balloon driver. Memory hot add will be added in a
subsequent patch and this requires some changes yet to be made on the host
side.

The policy engine on Windows hosts needs the guest to post memory status
periodically and it looks like committed_as is what it is expecting.
Since vm_committed_as is not currently an exported symbol, this patch set
also exports this symbol.

K. Y. Srinivasan (2):
  mm: Export vm_committed_as
  Drivers: hv: Add Hyper-V balloon driver

 drivers/hv/Kconfig      |    6 +
 drivers/hv/Makefile     |    1 +
 drivers/hv/hv_balloon.c | 1043 +++++++++++++++++++++++++++++++++++++++++++++++
 mm/mmap.c               |    1 +
 mm/nommu.c              |    1 +
 5 files changed, 1052 insertions(+), 0 deletions(-)
 create mode 100644 drivers/hv/hv_balloon.c

-- 
1.7.4.1

