Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424468Ab2LGU5O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 15:57:14 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:34141 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1424420Ab2LGU4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 15:56:45 -0500
Message-Id: <20121207205640.847087443@openvz.org>
User-Agent: quilt/0.60-1
Date: Sat, 08 Dec 2012 00:53:01 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>, Oleg Nesterov <oleg@redhat.com>,
        Andrey Vagin <avagin@openvz.org>, Al Viro <viro@ZenIV.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        James Bottomley <jbottomley@parallels.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
Subject: [patch 2/2] [PATCH -mm] docs: Update documentation about /proc/<pid>/fdinfo/<fd> fanotify output
References: <20121207205259.394558474@openvz.org>
Content-Disposition: inline; filename=docs-update-fainfo
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Pavel Emelyanov <xemul@parallels.com>
CC: Oleg Nesterov <oleg@redhat.com>
CC: Andrey Vagin <avagin@openvz.org>
CC: Al Viro <viro@ZenIV.linux.org.uk>
CC: Alexey Dobriyan <adobriyan@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: James Bottomley <jbottomley@parallels.com>
CC: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
CC: Alexey Dobriyan <adobriyan@gmail.com>
CC: Matthew Helsley <matt.helsley@gmail.com>
CC: "J. Bruce Fields" <bfields@fieldses.org>
CC: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
CC: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
---
 Documentation/filesystems/proc.txt |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

Index: linux-2.6.git/Documentation/filesystems/proc.txt
===================================================================
--- linux-2.6.git.orig/Documentation/filesystems/proc.txt
+++ linux-2.6.git/Documentation/filesystems/proc.txt
@@ -1696,21 +1696,27 @@ pair provide additional information part
 	If the kernel is built without exportfs support the file handle won't be
 	printed out.
 
-	For fanotify files the format is
+	If there is no inotify mark attached yet the 'inotify' line will be omitted.
 
-	pos:	0
-	flags:	02
-	fanotify ino:2 sdev:800013 mask:1 ignored_mask:40000000 fhandle-bytes:8 fhandle-type:1 f_handle:0200000000000000
-
-	or
+	For fanotify files the format is
 
 	pos:	0
 	flags:	02
-	fanotify mnt_id:13 mask:1 ignored_mask:40000000
+	fanotify flags:10 event-flags:0
+	fanotify mnt_id:12 mflags:40 mask:38 ignored_mask:40000003
+	fanotify ino:4f969 sdev:800013 mflags:0 mask:3b ignored_mask:40000000 fhandle-bytes:8 fhandle-type:1 f_handle:69f90400c275b5b4
+
+	where fanotify 'flags' and 'event-flags' are values used in fanotify_init
+	call, 'mnt_id' is the mount point identifier, 'mflags' is the value of
+	flags associated with mark which are tracked separately from events
+	mask. 'ino', 'sdev' are target inode and device, 'mask' is the events
+	mask and 'ignored_mask' is the mask of events which are to be ignored.
+	All in hex format. Incorporation of 'mflags', 'mask' and 'ignored_mask'
+	does provide information about flags and mask used in fanotify_mark
+	call [see fsnotify manpage for details].
 
-	where 'ino', 'sdev' are target inode and device, 'mnt_id' is the mount
-	point identifier, 'mask' is the events mask used and 'ignored_mask' is
-	the mask of events which are to be ignored. All in hex format.
+	While the first three lines are mandatory and always printed, the rest is
+	optional and may be omitted if no marks created yet.
 
 
 ------------------------------------------------------------------------------

