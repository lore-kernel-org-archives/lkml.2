Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571Ab1BPQMI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 11:12:08 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:21475
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751699Ab1BPQMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 11:12:06 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz4015Lzz1202hzzz2dh95h668h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
From: John Linn <john.linn@xilinx.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <catalin.marinas@arm.com>,
        <glikely@secretlab.ca>, <arnd@arndb.de>
Subject: [PATCH V3 0/4] ARM: Basic Xilinx Support
Date: Wed, 16 Feb 2011 09:11:52 -0700
X-Mailer: git-send-email 1.5.6.6
X-RCIS-Action: ALLOW
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <e195bee2-8509-43a8-bc1c-cf6136866dd9@VA3EHSMHS025.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


V3

I incorporated more feedback from Russell King.
Primarily clean up of the license header to remove
the address. 

Also minor cleanup of the Kconfig and Makefile for the board
to match the MACH_XILINX entry in the machine ID database.

These changes were tested on 2.6.38-rc4 and rc5.

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
 arch/arm/mach-xilinx/Makefile                   |    9 
 arch/arm/mach-xilinx/Makefile.boot              |    3 
 arch/arm/mach-xilinx/board_ep107.c              |   82 ++++++
 arch/arm/mach-xilinx/common.c                   |  113 ++++++++
 arch/arm/mach-xilinx/common.h                   |   31 ++
 arch/arm/mach-xilinx/include/mach/clkdev.h      |   33 ++
 arch/arm/mach-xilinx/include/mach/debug-macro.S |   36 ++
 arch/arm/mach-xilinx/include/mach/entry-macro.S |   30 ++
 arch/arm/mach-xilinx/include/mach/hardware.h    |   18 +
 arch/arm/mach-xilinx/include/mach/io.h          |   33 ++
 arch/arm/mach-xilinx/include/mach/irqs.h        |   29 ++
 arch/arm/mach-xilinx/include/mach/memory.h      |   23 +
 arch/arm/mach-xilinx/include/mach/system.h      |   28 ++
 arch/arm/mach-xilinx/include/mach/timex.h       |   24 +
 arch/arm/mach-xilinx/include/mach/uart.h        |   31 ++
 arch/arm/mach-xilinx/include/mach/uncompress.h  |   47 +++
 arch/arm/mach-xilinx/include/mach/vmalloc.h     |   20 +
 arch/arm/mach-xilinx/include/mach/xilinx_soc.h  |   47 +++
 arch/arm/mach-xilinx/timer.c                    |  302 +++++++++++++++++++++++-
 arch/arm/mm/Kconfig                             |    3 
 23 files changed, 964 insertions(+), 6 deletions(-)

This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


