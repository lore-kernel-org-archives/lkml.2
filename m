Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707Ab0LUMkP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 07:40:15 -0500
Received: from jester.euphonynet.be ([212.87.96.13]:38685 "EHLO
	mailpush2.euphonynet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab0LUMkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 07:40:13 -0500
From: Bart Van Assche <bvanassche@acm.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] docs/sysfs: Update directory/kobject documentation.
Date: Tue, 21 Dec 2010 13:09:23 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.34.6-scst; KDE/4.4.4; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, Tejun Heo <tj@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201012211309.23159.bvanassche@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some time ago the way how sysfs stores a pointer to a kobject
corresponding to a directory was modified. This patch brings the
documentation again in sync with the implementation.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Greg KH <greg@kroah.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 Documentation/filesystems/sysfs.txt |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/Documentation/filesystems/sysfs.txt b/Documentation/filesystems/sysfs.txt
index 5d1335f..2ed95f9 100644
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
1.7.1

