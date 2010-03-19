Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162Ab0CSPWp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 11:22:45 -0400
Received: from kroah.org ([198.145.64.141]:45906 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752502Ab0CSPTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 11:19:00 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Yinghai Lu <yinghai@kernel.org>,
       Eric Biederman <ebiederm@xmission.com>
Subject: [PATCH 05/12] sysfs: fix sysfs lockdep warning in mlx4 code
Date: Fri, 19 Mar 2010 08:18:48 -0700
Message-Id: <1269011935-8886-5-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <20100319151311.GA8541@kroah.com>
References: <20100319151311.GA8541@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a sysfs lockdep warning in the mlx4 code.

Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/mlx4/main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/mlx4/main.c b/drivers/net/mlx4/main.c
index 8f6e816..b402a95 100644
--- a/drivers/net/mlx4/main.c
+++ b/drivers/net/mlx4/main.c
@@ -1023,6 +1023,7 @@ static int mlx4_init_port_info(struct mlx4_dev *dev, int port)
 	info->port_attr.attr.mode = S_IRUGO | S_IWUSR;
 	info->port_attr.show      = show_port_type;
 	info->port_attr.store     = set_port_type;
+	sysfs_attr_init(&info->port_attr.attr);
 
 	err = device_create_file(&dev->pdev->dev, &info->port_attr);
 	if (err) {
-- 
1.7.0.2

