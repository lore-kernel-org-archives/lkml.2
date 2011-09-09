Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759696Ab1IISbl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 14:31:41 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:38204 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759682Ab1IISbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 14:31:40 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, JBeulich@novell.com,
        jeremy.fitzhardinge@citrix.com, axboe@kernel.dk
Subject: [PATCH] xen-blk[front|back] FUA additions.
Date: Fri,  9 Sep 2011 14:30:58 -0400
Message-Id: <1315593060-20031-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090207.4E6A5B80.00B1,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am proposing these two patches for 3.2. They allow the backend
to process the REQ_FUA request as well. Previous to these patches
it only did REQ_FLUSH. There is also a bug-fix for the logic
of how barrier/flushes were handled.

The patches are based on a branch which also has 'feature-discard'
patches, so they won't apply nativly on top of 3.1-rc5.

Please review and if there are no concerns I will send a proper
git pull to Jens to pick up the whole branch for 3.2.

 drivers/block/xen-blkback/blkback.c |   11 ++++++-----
 drivers/block/xen-blkfront.c        |   12 ++++++------
 drivers/block/xen-blkfront.c          |    8 ++++----
 3 files changed, 16 insertions(+), 15 deletions(-)

The full git tree is currently at my backup git tree:

git://oss.oracle.com/git/kwilk/xen.git stable/for-jens-3.2

