Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab1CZRIm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 13:08:42 -0400
Received: from [123.120.158.88] ([123.120.158.88]:35152 "EHLO enigma.site"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751981Ab1CZRIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 13:08:40 -0400
X-Greylist: delayed 573 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 Mar 2011 13:08:40 EDT
From: Coly Li <bosong.ly@taobao.com>
To: linux-kernel@vger.kernel.org
Cc: Coly Li <bosong.ly@taobao.com>, Greg KH <gregkh@suse.de>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Wang Cong <xiyou.wangcong@gmail.com>
Subject: [PATCH 0/4] use BUG_ON correctly, v4
Date: Sun, 27 Mar 2011 01:26:51 +0800
Message-Id: <1301160415-24569-1-git-send-email-bosong.ly@taobao.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of BUG_ON() implementations use unlikely() internally for better
branch prediction results. The following method to use BUG_ON() with
an explicit unlikely() doesn't make things better and is unwelcome:
	BUG_ON(unlikely(condition));
Source code should use BUG_ON() just with condition code.

For arch implementation of BUG_ON(), there are feed backs for v2 patch
set from MIPS and PowerPC developers than neither explicit no implicit
unlikely() does help anything.

Therefore using unlikely() explicit with BUG_ON() is always a bug. This
patch set removes all incorrect BUG_ON() usage.

Patch "Staging: wl_cfg80211.c: use BUG_ON correctly" is merged into
upstream (commit d7ddd169), no longer in v4 patch set. For v4 
patch set, proper maintainers are added into Cc list by the help of
scripts/get_maintainer.pl.

Cc: Greg KH <gregkh@suse.de>
Cc: Yong Zhang <yong.zhang0@gmail.com>
Cc: Wang Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Coly Li <bosong.ly@taobao.com>
---
 drivers/dma/iop-adma.c    |    6 +++---
 drivers/dma/mv_xor.c      |    6 +++---
 drivers/dma/ppc4xx/adma.c |    8 ++++----
 drivers/scsi/scsi_lib.c   |    4 ++--
 4 files changed, 12 insertions(+), 12 deletions(-)
