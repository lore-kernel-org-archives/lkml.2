Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932391Ab2JQPqA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 11:46:00 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40035 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932202Ab2JQPpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 11:45:14 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Will Deacon <will.deacon@arm.com>
Subject: [RESEND PATCH 0/4] Fix endianness of generic I/O accessors
Date: Wed, 17 Oct 2012 16:45:00 +0100
Message-Id: <1350488704-3711-1-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is a resend of the patches I originally sent a while back:

  http://marc.info/?l=linux-kernel&m=133552356617938&w=2

There was some loose conclusion then that documentation needed to be
updated, which I didn't get round to doing. However, after discussion
with Ben at LPC (following his `Big and Little Endian inside/out'
presentation), he encouraged me to resend the patches anyway.

So here they are. I also included two extra patches to fix the MMC and
ethernet drivers used on the ARM64 model, which is where I came across
this issue in the first place.

Comments welcome,

Will

Big endian is not dead -- it just smells funny.


Will Deacon (4):
  asm-generic: io: remove {read,write} string functions
  asm-generic: io: don't perform swab during {in,out} string functions
  mmc: mmci: use io{read,write}*_rep accessors instead of string
    functions
  net: smc91x: use io{read,write}*_rep accessors instead of string
    functions

 drivers/mmc/host/mmci.c            |    8 +++---
 drivers/net/ethernet/smsc/smc91x.h |   20 ++++++++--------
 include/asm-generic/io.h           |   42 +++++------------------------------
 3 files changed, 20 insertions(+), 50 deletions(-)

-- 
1.7.4.1

