Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab0HXEYm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 00:24:42 -0400
Received: from kroah.org ([198.145.64.141]:56429 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753938Ab0HXEYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 00:24:18 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Dan Carpenter <error27@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 4/6] rocket: add a mutex_unlock()
Date: Mon, 23 Aug 2010 21:24:04 -0700
Message-Id: <1282623846-17050-4-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100824040508.GC16749@kroah.com>
References: <20100824040508.GC16749@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>

This path needs a mutex_unlock().  This is stuff from the bkl to mutex
transition.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Acked-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/rocket.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/char/rocket.c b/drivers/char/rocket.c
index 79c3bc6..7c79d24 100644
--- a/drivers/char/rocket.c
+++ b/drivers/char/rocket.c
@@ -1244,6 +1244,7 @@ static int set_config(struct tty_struct *tty, struct r_port *info,
 		}
 		info->flags = ((info->flags & ~ROCKET_USR_MASK) | (new_serial.flags & ROCKET_USR_MASK));
 		configure_r_port(tty, info, NULL);
+		mutex_unlock(&info->port.mutex);
 		return 0;
 	}
 
-- 
1.7.2

