Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761132Ab2DKUHb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 16:07:31 -0400
Received: from na3sys010aog103.obsmtp.com ([74.125.245.74]:49461 "HELO
	na3sys010aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754625Ab2DKUH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 16:07:29 -0400
From: Roland Dreier <roland@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
Date: Wed, 11 Apr 2012 13:07:22 -0700
Message-Id: <1334174842-13632-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git tags/rdma-for-linus

----------------------------------------------------------------
Fix regression in the /sys/class/infiniband/.../rate attribute -- old
kernels used to just return something, even if the underlying value was
out-of-bounds, while 3.4-rc1 returned EINVAL to userspace.  This breaks
some applications that check for the error, so go back to the old
behavior.

----------------------------------------------------------------
Or Gerlitz (1):
      IB/mlx4: Don't return an invalid speed when a port is down

Roland Dreier (1):
      IB/core: Don't return EINVAL from sysfs rate attribute for invalid speeds

 drivers/infiniband/core/sysfs.c   |    9 +++++----
 drivers/infiniband/hw/mlx4/main.c |    5 +++++
 2 files changed, 10 insertions(+), 4 deletions(-)
