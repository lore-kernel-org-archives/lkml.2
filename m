Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256Ab0CSPTL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 11:19:11 -0400
Received: from kroah.org ([198.145.64.141]:45902 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466Ab0CSPTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 11:19:00 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Yinghai Lu <yinghai@kernel.org>,
       Eric Biederman <ebiederm@xmission.com>
Subject: [PATCH 04/12] sysfs: fix sysfs lockdep warning in infiniband code
Date: Fri, 19 Mar 2010 08:18:47 -0700
Message-Id: <1269011935-8886-4-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <20100319151311.GA8541@kroah.com>
References: <20100319151311.GA8541@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a sysfs lockdep warning in the infiniband code.

Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/infiniband/core/sysfs.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index 1558bb7..f901957 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -461,6 +461,7 @@ alloc_group_attrs(ssize_t (*show)(struct ib_port *,
 		element->attr.attr.mode  = S_IRUGO;
 		element->attr.show       = show;
 		element->index		 = i;
+		sysfs_attr_init(&element->attr.attr);
 
 		tab_attr[i] = &element->attr.attr;
 	}
-- 
1.7.0.2

