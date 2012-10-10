Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300Ab2JJTlN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 15:41:13 -0400
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:51957
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753977Ab2JJTlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 15:41:08 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        andi@firstfloor.org, akpm@linux-foundation.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH V1 0/2] Drivers: hv 
Date: Wed, 10 Oct 2012 13:01:10 -0700
Message-Id: <1349899270-503-1-git-send-email-kys@microsoft.com>
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

In this version I have addressed comments from Greg KH, Rusty Russell
and Andrew Morton:

1) Cleaned up the copyright notice in hv_balloon.c
2) Fixed a typo in Kconfig help string
3) Exported the needed symbol as a GPL symbol
4) Changed the hot_add module parameter to be a boolean variable
5) Got rid of the code that manipulated totalram_pages
6) Cleaned up the allocation flags.

K. Y. Srinivasan (2):
  mm: Export vm_committed_as
  Drivers: hv: Add Hyper-V balloon driver

 drivers/hv/Kconfig      |    6 +
 drivers/hv/Makefile     |    1 +
 drivers/hv/hv_balloon.c | 1041 +++++++++++++++++++++++++++++++++++++++++++++++
 mm/mmap.c               |    1 +
 mm/nommu.c              |    1 +
 5 files changed, 1050 insertions(+), 0 deletions(-)
 create mode 100644 drivers/hv/hv_balloon.c

-- 
1.7.4.1

