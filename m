Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125Ab1DES2P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 14:28:15 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:48545
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753951Ab1DES2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 14:28:13 -0400
X-SpamScore: -4
X-BigFish: VPS-4(zz4015Lzz1202hzz8275bhz2dh95h668h839h64h)
X-Spam-TCS-SCL: 3:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
From: John Linn <john.linn@xilinx.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <catalin.marinas@arm.com>,
        <glikely@secretlab.ca>, <jamie@jamieiles.com>, <arnd@arndb.de>,
        <nicolas.pitre@linaro.org>
Subject: [PATCH V6 0/5] ARM: Basic Xilinx Support
Date: Tue, 5 Apr 2011 12:28:01 -0600
X-Mailer: git-send-email 1.5.4.7
X-RCIS-Action: ALLOW
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <9c88535e-0f32-4bae-ba87-05ee7c3cafdb@VA3EHSMHS024.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Some minor updates since V5 listed below. This patch set was tested
against the linus tree.  An extra optional patch for device tree
is now in the series and is described below.

Thanks,
John

V6

Renamed mach-xilinx to mach-zynq since the product name has been
released. This rippled thru it all, but only a minor change.

This patch series now includes an optional patch at the end as
it supports device tree which is dependent on Grant's tree.

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

 Documentation/devicetree/bindings/arm/xilinx.txt |    7 
 arch/arm/Kconfig                                 |   14 +
 arch/arm/Makefile                                |    1 
 arch/arm/boot/dts/zynq-ep107.dts                 |   52 ++++
 arch/arm/mach-zynq/Kconfig                       |   14 +
 arch/arm/mach-zynq/Makefile                      |    9 
 arch/arm/mach-zynq/Makefile.boot                 |    3 
 arch/arm/mach-zynq/board_ep107.c                 |   93 +++++++
 arch/arm/mach-zynq/common.c                      |  127 +++++++++
 arch/arm/mach-zynq/common.h                      |   31 ++
 arch/arm/mach-zynq/include/mach/clkdev.h         |   33 ++
 arch/arm/mach-zynq/include/mach/debug-macro.S    |   36 ++
 arch/arm/mach-zynq/include/mach/entry-macro.S    |   30 ++
 arch/arm/mach-zynq/include/mach/hardware.h       |   18 +
 arch/arm/mach-zynq/include/mach/io.h             |   33 ++
 arch/arm/mach-zynq/include/mach/irqs.h           |   29 ++
 arch/arm/mach-zynq/include/mach/memory.h         |   23 +
 arch/arm/mach-zynq/include/mach/system.h         |   28 ++
 arch/arm/mach-zynq/include/mach/timex.h          |   23 +
 arch/arm/mach-zynq/include/mach/uart.h           |   25 +
 arch/arm/mach-zynq/include/mach/uncompress.h     |   51 +++
 arch/arm/mach-zynq/include/mach/vmalloc.h        |   20 +
 arch/arm/mach-zynq/include/mach/zynq_soc.h       |   49 +++
 arch/arm/mach-zynq/timer.c                       |  298 ++++++++++++++++++++++-
 arch/arm/mm/Kconfig                              |    3 
 25 files changed, 1042 insertions(+), 8 deletions(-)


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


