Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934692Ab2J3VSr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 17:18:47 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:46755 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934639Ab2J3VSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 17:18:41 -0400
From: Behan Webster <behanw@converseincode.com>
To: balbi@ti.com, davem@davemloft.net
Cc: linux-usb@vger.kernel.org, netfilter-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Behan Webster <behanw@converseincode.com>
Subject: [PATCH V2 0/3] Removing the use of VLAIS from USB Gadget and netfilter
Date: Tue, 30 Oct 2012 17:18:54 -0400
Message-Id: <1351631937-21455-1-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a V2 version of the patch set I previously sent out. Since the use of a
new valign.h file spans both the USB and netfilter subsystems, I should have
sent out all 3 patches to both trees at once. Assuming all is well, hopefully
both subsystems can cooperate to get these patches in without causing
conflicts.

The use of variable length arrays in structs (VLAIS) in the Linux Kernel code
precludes the use of compilers which don't implement VLAIS (for instance the
Clang compiler). The LLVMLinux Project is working towards the ability of
providing the Linux kernel developer the choice of using the Clang compiler
toolchain. This is a part of a series of patches which remove the use of VLAIS
from crypto code, dm-crypt, jbd2, libcrc32c, netfilter, and usb gadget. Other
patches to allow Clang to be used to compile the Linux kernel will follow.

Behan Webster (2):
  Helper macros used for replacing the use of VLAIS
  Remove VLAIS usage from gadget code

Jan-Simon Möller (1):
  Remove VLAIS usage from netfilter

 drivers/usb/gadget/f_fs.c   |  106 +++++++++++++++++++++++++------------------
 include/linux/valign.h      |   87 +++++++++++++++++++++++++++++++++++
 net/netfilter/xt_repldata.h |   40 +++++++++-------
 3 files changed, 172 insertions(+), 61 deletions(-)
 create mode 100644 include/linux/valign.h

-- 
1.7.9.5

