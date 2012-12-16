Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140Ab2LPRkZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 12:40:25 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:23931 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595Ab2LPRkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 12:40:24 -0500
Date: Sun, 16 Dec 2012 12:40:15 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] (swiotlb) stable/for-linus-3.8-rc0-tag
Message-ID: <20121216172609.GA31701@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Linus,

Please git pull the following tag:

git pull git://git.kernel.org/pub/scm/linux/kernel/git/konrad/swiotlb.git stable/for-linus-3.8-rc0-tag

which has one feature in the SWIOTLB code. That is to remove
the multitude of phys_to_virt/virt_to_phys calls and instead
operate on the physical addresses instead of virtual in many
of the internal functions. This does provide a speed up in interrupt
handlers that do DMA operations and use SWIOTLB.

Please pull!

 drivers/xen/swiotlb-xen.c |   25 ++--
 include/linux/swiotlb.h   |   20 ++--
 lib/swiotlb.c             |  269 +++++++++++++++++++++++----------------------
 3 files changed, 163 insertions(+), 151 deletions(-)

Alexander Duyck (7):
      swiotlb: Make io_tlb_end a physical address instead of a virtual one
      swiotlb: Make io_tlb_start a physical address instead of a virtual one
      swiotlb: Make io_tlb_overflow_buffer a physical address
      swiotlb: Return physical addresses when calling swiotlb_tbl_map_single
      swiotlb: Use physical addresses for swiotlb_tbl_unmap_single
      swiotlb: Use physical addresses instead of virtual in swiotlb_tbl_sync_single
      swiotlb: Do not export swiotlb_bounce since there are no external consumers

