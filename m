Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239Ab1CPVLk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 17:11:40 -0400
Received: from kroah.org ([198.145.64.141]:42516 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753675Ab1CPVLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 17:11:31 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>, Tejun Heo <tj@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 02/50] docs/sysfs: Update directory/kobject documentation.
Date: Wed, 16 Mar 2011 14:10:40 -0700
Message-Id: <1300309888-5028-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300309888-5028-1-git-send-email-gregkh@suse.de>
References: <20110316205204.GA2686@kroah.com>
 <1300309888-5028-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

Some time ago the way how sysfs stores a pointer to a kobject
corresponding to a directory was modified. This patch brings the
documentation again in sync with the implementation.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/filesystems/sysfs.txt |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/Documentation/filesystems/sysfs.txt b/Documentation/filesystems/sysfs.txt
index 5d1335fae..2ed95f9 100644
--- a/Documentation/filesystems/sysfs.txt
+++ b/Documentation/filesystems/sysfs.txt
@@ -39,10 +39,12 @@ userspace. Top-level directories in sysfs represent the common
 ancestors of object hierarchies; i.e. the subsystems the objects
 belong to. 
 
-Sysfs internally stores the kobject that owns the directory in the
-->d_fsdata pointer of the directory's dentry. This allows sysfs to do
-reference counting directly on the kobject when the file is opened and
-closed. 
+Sysfs internally stores a pointer to the kobject that implements a
+directory in the sysfs_dirent object associated with the directory. In
+the past this kobject pointer has been used by sysfs to do reference
+counting directly on the kobject whenever the file is opened or closed.
+With the current sysfs implementation the kobject reference count is
+only modified directly by the function sysfs_schedule_callback().
 
 
 Attributes
-- 
1.7.4.1

