Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab1C3AYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 20:24:18 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:15156
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753569Ab1C3AYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 20:24:17 -0400
X-SpamScore: -4
X-BigFish: VPS-4(zz4015Lzz1202hzz8275bhz2dh95h668h64h)
X-Spam-TCS-SCL: 3:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
From: John Linn <john.linn@xilinx.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <catalin.marinas@arm.com>,
        <glikely@secretlab.ca>, <jamie@jamieiles.com>, <arnd@arndb.de>
Subject: [PATCH V5 0/4] ARM: Basic Xilinx Support
Date: Tue, 29 Mar 2011 18:24:07 -0600
X-Mailer: git-send-email 1.5.6.6
X-RCIS-Action: ALLOW
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <54ecc6c4-1a00-4581-8390-0b42d705f29b@VA3EHSMHS018.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a resend of V5. There have been no updates since V5. 

The mach-types got updated with the Xilinx platforms in 
2.6.39-rc1.  I retested with 2.6.39-rc1 and these patches.
Kconfigs and Makefile only had to be tweaked to apply.

I am putting a tree into linux-next based on these patches.

git://git.xilinx.com/linux-2.6-xlnx arm-next

Thanks,
John

V5

Minor cleanups based on feedback from Russell, Jamie
and Arnd.  Nothing big.

This patch set was tested against a tree based on Linus's
current 2.6.38-rcX tree, then Russell's p2v-stable merged in. 

Other than the update to mach-types that is missing for the
board, this should merge in easily in the next merge window
is my hope.

I'm making these patches available at git://git.xilinx.com in
linux-2.6-xlnx/arm-mainline.

V4

I incorporated more feedback from Jamie Iles. It was 
primariy cleanup with the only significant change
being a move to using raw_read/write in the uncompressor
uart code.

The other changes were minor updates so that the patch
set applies to linux-next.

This patch set is now tested against the linux-next branch
from pub/scm/linux/kernel/git/sfr/linux-next.git.

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

 arch/arm/Kconfig                                |   14 +
 arch/arm/Makefile                               |    1 
 arch/arm/mach-xilinx/Kconfig                    |   14 +
 arch/arm/mach-xilinx/Makefile                   |    9 
 arch/arm/mach-xilinx/Makefile.boot              |    3 
 arch/arm/mach-xilinx/board_ep107.c              |   82 ++++++
 arch/arm/mach-xilinx/common.c                   |  113 +++++++++
 arch/arm/mach-xilinx/common.h                   |   31 ++
 arch/arm/mach-xilinx/include/mach/clkdev.h      |   33 ++
 arch/arm/mach-xilinx/include/mach/debug-macro.S |   36 ++
 arch/arm/mach-xilinx/include/mach/entry-macro.S |   30 ++
 arch/arm/mach-xilinx/include/mach/hardware.h    |   18 +
 arch/arm/mach-xilinx/include/mach/io.h          |   33 ++
 arch/arm/mach-xilinx/include/mach/irqs.h        |   29 ++
 arch/arm/mach-xilinx/include/mach/memory.h      |   23 +
 arch/arm/mach-xilinx/include/mach/system.h      |   28 ++
 arch/arm/mach-xilinx/include/mach/timex.h       |   22 +
 arch/arm/mach-xilinx/include/mach/uart.h        |   25 ++
 arch/arm/mach-xilinx/include/mach/uncompress.h  |   61 ++++
 arch/arm/mach-xilinx/include/mach/vmalloc.h     |   20 +
 arch/arm/mach-xilinx/include/mach/xilinx_soc.h  |   47 +++
 arch/arm/mach-xilinx/timer.c                    |  293 +++++++++++++++++++++++-
 arch/arm/mm/Kconfig                             |    3 
 23 files changed, 962 insertions(+), 6 deletions(-)

This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


