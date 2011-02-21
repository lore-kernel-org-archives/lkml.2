Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953Ab1BUOdl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 09:33:41 -0500
Received: from smtp.nokia.com ([147.243.1.47]:62257 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082Ab1BUOdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 09:33:40 -0500
From: David Cohen <dacohen@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, peterz@infradead.org, linux-omap@vger.kernel.org,
        linux-media@vger.kernel.org, David Cohen <dacohen@gmail.com>
Subject: [PATCH v2 0/1] Fix linux/wait.h header file
Date: Mon, 21 Feb 2011 16:38:50 +0200
Message-Id: <1298299131-17695-1-git-send-email-dacohen@gmail.com>
X-Mailer: git-send-email 1.7.2.3
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

OMAP2 camera driver compilation is broken due to problems on linux/wait.h header
file:

drivers/media/video/omap24xxcam.c: In function 'omap24xxcam_vbq_complete':
drivers/media/video/omap24xxcam.c:414: error: 'TASK_NORMAL' undeclared (first use in this function)
drivers/media/video/omap24xxcam.c:414: error: (Each undeclared identifier is reported only once
drivers/media/video/omap24xxcam.c:414: error: for each function it appears in.)
make[3]: *** [drivers/media/video/omap24xxcam.o] Error 1
make[2]: *** [drivers/media/video] Error 2
make[1]: *** [drivers/media] Error 2
make: *** [drivers] Error 2

This file defines macros wake_up*() which use TASK_* defined on linux/sched.h.
But sched.h cannot be included on wait.h due to a circular dependency between
both files. This patch fixes such compilation and the circular dependency
problem.

Br,

David
---

David Cohen (1):
  headers: fix circular dependency between linux/sched.h and
    linux/wait.h

 include/linux/sched.h      |   58 +-----------------------------------------
 include/linux/task_state.h |   61 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/wait.h       |    1 +
 3 files changed, 63 insertions(+), 57 deletions(-)
 create mode 100644 include/linux/task_state.h

-- 
1.7.2.3

