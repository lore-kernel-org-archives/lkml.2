Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477Ab1BUK27 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 05:28:59 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34033 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755307Ab1BUK26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 05:28:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=pttL61MSbBX6B6C/fFgORhKbCqcZ/GgRXAPyh8brQB/uXHXIKsyjL4Sl41dYtzNJWo
         rkJTL8bQ5YgkV5ePIgS4Q4hOY6fIfLhwYEdnhRUkPt7Pskc8NakDINg9qbemkYGV0tER
         ZlwwM8KDjEITahs02mMcPeY3hJHcmqIwWq9mM=
From: David Cohen <dacohen@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, peterz@infradead.org, linux-omap@vger.kernel.org,
        linux-media@vger.kernel.org, David Cohen <dacohen@gmail.com>
Subject: [PATCH 0/1] Fix linux/wait.h header file
Date: Mon, 21 Feb 2011 12:20:48 +0200
Message-Id: <1298283649-24532-1-git-send-email-dacohen@gmail.com>
X-Mailer: git-send-email 1.7.1
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

 include/linux/sched.h      |   61 +-----------------------------------------
 include/linux/task_sched.h |   64 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/wait.h       |    1 +
 3 files changed, 66 insertions(+), 60 deletions(-)
 create mode 100644 include/linux/task_sched.h

