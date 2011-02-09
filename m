Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab1BIRBD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 12:01:03 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:29681
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754389Ab1BIRA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 12:00:58 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz4015Lzz1202hzzz2dh95h668h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
From: John Linn <john.linn@xilinx.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <catalin.marinas@arm.com>,
        <glikely@secretlab.ca>
Subject: [PATCH V2 0/4] ARM: Basic Xilinx Support
Date: Wed, 9 Feb 2011 10:00:41 -0700
X-Mailer: git-send-email 1.5.6.6
X-RCIS-Action: ALLOW
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <84ef3aa4-c485-4a15-ad56-68dbf6d52e4a@VA3EHSMHS006.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

V2

I incorporated review comments from Russell King and Jamie Iles.

Each patch has V2 comments describing the details. The order of
each patch in the series did change.

Thanks a lot to them for the detailed review as this patch set
is much cleaner and improved (I think anyway).  

Thanks for comments from Arnd and Grant also.
This was tested against 2.6.38-rc4.

----

This patch series adds very basic support for the Xilinx ARM platform.
The entire patch set must be used, I only broke it up into logical 
pieces to make the review easier (I hope). 

I would like to get the review feedback and make any changes, but after
that I need to change mach-xilinx to the real product name.  The real
product name is expected to be released by marketing very soon.

There's always the option of keeping mach-xilinx and then only 
documenting the product name in the Kconfig. I'm less in favor of that
but it could be ok.

This code has been tested against 2.6.38-rc2, r3, and against head. The
only checkpatch warnings are about volatile in the uncompress.h file
and this method I used seems normal.

Thanks,
John

 arch/arm/Kconfig                                |   13 +
 arch/arm/Makefile                               |    1 
 arch/arm/mach-xilinx/Kconfig                    |   14 +
 arch/arm/mach-xilinx/Makefile                   |    8 
 arch/arm/mach-xilinx/Makefile.boot              |    3 
 arch/arm/mach-xilinx/board_ep107.c              |   82 ++++++
 arch/arm/mach-xilinx/common.c                   |  113 ++++++++
 arch/arm/mach-xilinx/common.h                   |   31 ++
 arch/arm/mach-xilinx/include/mach/clkdev.h      |   33 ++
 arch/arm/mach-xilinx/include/mach/debug-macro.S |   36 ++
 arch/arm/mach-xilinx/include/mach/entry-macro.S |   29 ++
 arch/arm/mach-xilinx/include/mach/hardware.h    |   18 +
 arch/arm/mach-xilinx/include/mach/io.h          |   33 ++
 arch/arm/mach-xilinx/include/mach/irqs.h        |   28 ++
 arch/arm/mach-xilinx/include/mach/memory.h      |   23 +
 arch/arm/mach-xilinx/include/mach/system.h      |   28 ++
 arch/arm/mach-xilinx/include/mach/timex.h       |   24 +
 arch/arm/mach-xilinx/include/mach/uart.h        |   30 ++
 arch/arm/mach-xilinx/include/mach/uncompress.h  |   46 +++
 arch/arm/mach-xilinx/include/mach/vmalloc.h     |   20 +
 arch/arm/mach-xilinx/include/mach/xilinx_soc.h  |   47 +++
 arch/arm/mach-xilinx/timer.c                    |  302 +++++++++++++++++++++++-
 arch/arm/mm/Kconfig                             |    3 
 23 files changed, 959 insertions(+), 6 deletions(-)

This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


