Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128Ab0CRJI1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 05:08:27 -0400
Received: from mail-gx0-f217.google.com ([209.85.217.217]:64302 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989Ab0CRJIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 05:08:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=WP+anN9WvJnsX/Y6cwyUFfe354iYmATjad/6K0Yox4Gnj+fZ7kEr7u2O6IETW6vzVl
         q8QMr/wfNUrgxiic872C/AlzdXoPKzRfIY8V4zlPiz78gD3wmPy+R5T6y3CDv8bbfRfT
         neZN9RZtOwc/AMCIjKgPByNcT4oenXD1WRyHE=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Neil Brown <neilb@suse.de>,
       linux-raid@vger.kernel.org
Subject: [PATCH 11/12] md: convert cpu notifier to return encapsulate errno value
Date: Thu, 18 Mar 2010 18:05:23 +0900
Message-Id: <1268903124-10237-11-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1268903124-10237-1-git-send-email-akinobu.mita@gmail.com>
References: <1268903124-10237-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By the previous modification, the cpu notifier can return encapsulate
errno value. This converts the cpu notifiers for raid5.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
---
 drivers/md/raid5.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 70ffbd0..a711ba3 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4659,7 +4659,7 @@ static int raid456_cpu_notify(struct notifier_block *nfb, unsigned long action,
 			kfree(percpu->scribble);
 			pr_err("%s: failed memory allocation for cpu%ld\n",
 			       __func__, cpu);
-			return NOTIFY_BAD;
+			return notifier_from_errno(-ENOMEM);
 		}
 		break;
 	case CPU_DEAD:
-- 
1.6.0.6

