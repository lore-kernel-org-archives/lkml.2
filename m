Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851Ab1AKLId (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 06:08:33 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:57657 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755776Ab1AKLIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 06:08:14 -0500
To: Nick Piggin <npiggin@gmail.com>
CC: marco.stornelli@gmail.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-reply-to: <AANLkTikJjL6XEDJiYSh_J_rT+5LRUNj5EKDzCQ-852D7@mail.gmail.com>
	(message from Nick Piggin on Tue, 11 Jan 2011 20:57:58 +1100)
Subject: Re: Important for fs devs: rcu-walk merged upstream
References: <AANLkTimBrR1LkVHOxZA=UUmKsnxfsFLr9z_AhXUHQ_7N@mail.gmail.com>
	<4D282A17.4040104@gmail.com> <AANLkTikJjL6XEDJiYSh_J_rT+5LRUNj5EKDzCQ-852D7@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Message-Id: <E1Pcc5C-0007PC-LS@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 11 Jan 2011 12:08:10 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Jan 2011, Nick Piggin wrote:
> On Saturday, 8 January 2011, Marco Stornelli <marco.stornelli@gmail.com> wrote:
> > Il 08/01/2011 03:54, Nick Piggin ha scritto:
> >> The vfs-scale branch is now upstream. If you haven't
> >> looked yet, your filesystem is likely to have been
> >> touched, so check it out.
> >>
> >> Also look at Documentation/filesystems/porting and
> >> path-lookup.txt.
> >
> > Nick, in the porting file I read:
> >
> > ..........hazards on dentries and inodes (see
> > Documentation/filesystems/path-walk.txt). ..........
> >  ^^^^^^^^^^^^^
> >
> > Should it be "path-lookup.txt"?
> >
> > Marco
> >
> 
> Hi, yes thanks I'll fix it

Also you use IPERM_RCU instead of IPERM_FLAG_RCU in the documentation.

Thanks,
Miklos


diff --git a/Documentation/filesystems/porting b/Documentation/filesystems/porting
index 07a32b4..c2819ee 100644
--- a/Documentation/filesystems/porting
+++ b/Documentation/filesystems/porting
@@ -383,5 +383,5 @@ Documentation/filesystems/vfs.txt for more details.
 
 	permission and check_acl are inode permission checks that are called
 on many or all directory inodes on the way down a path walk (to check for
-exec permission). These must now be rcu-walk aware (flags & IPERM_RCU). See
-Documentation/filesystems/vfs.txt for more details.
+exec permission). These must now be rcu-walk aware (flags & IPERM_FLAG_RCU).
+See Documentation/filesystems/vfs.txt for more details.
diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index fbb324e..de8a967 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -415,9 +415,9 @@ otherwise noted.
   permission: called by the VFS to check for access rights on a POSIX-like
   	filesystem.
 
-	May be called in rcu-walk mode (flags & IPERM_RCU). If in rcu-walk
-	mode, the filesystem must check the permission without blocking or
-	storing to the inode.
+	May be called in rcu-walk mode (flags & IPERM_FLAG_RCU). If in
+	rcu-walk mode, the filesystem must check the permission without
+	blocking or storing to the inode.
 
 	If a situation is encountered that rcu-walk cannot handle, return
 	-ECHILD and it will be called again in ref-walk mode.
5B5B
