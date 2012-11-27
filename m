Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab2K0Wr5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 17:47:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49792 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755198Ab2K0Wr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 17:47:56 -0500
Date: Tue, 27 Nov 2012 14:47:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org, oleg@redhat.com,
        rientjes@google.com, tvrtko.ursulin@onelan.co.uk,
        linux-kernel@vger.kernel.org, Andrey Vagin <avagin@openvz.org>
Subject: Re: [patch -mm 4/4] docs: Add documentation about
 /proc/<pid>/fdinfo/<fd> output
Message-Id: <20121127144754.5a617e12.akpm@linux-foundation.org>
In-Reply-To: <20121122212235.690256454@openvz.org>
References: <20121122211522.075455799@openvz.org>
	<20121122212235.690256454@openvz.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Nov 2012 01:15:26 +0400
Cyrill Gorcunov <gorcunov@openvz.org> wrote:

>  Documentation/filesystems/proc.txt |   81 +++++++++++++++++++++++++++++++++++++

Looks good to me.  Here's a small tune-up:

--- a/Documentation/filesystems/proc.txt~docs-add-documentation-about-proc-pid-fdinfo-fd-output-fix
+++ a/Documentation/filesystems/proc.txt
@@ -1639,7 +1639,7 @@ if precise results are needed.
 This file provides information associated with an opened file. The regular
 files have at least two fields -- 'pos' and 'flags'. The 'pos' represents
 the current offset of the opened file in decimal form [see lseek(2) for
-details] and the 'flags' denotes octal O_xxx mask the file has been
+details] and 'flags' denotes the octal O_xxx mask the file has been
 created with [see open(2) for details].
 
 A typical output is
@@ -1648,7 +1648,7 @@ A typical output is
 	flags:	0100002
 
 The files such as eventfd, fsnotify, signalfd, epoll among the regular pos/flags
-pair provide additional information peculiar to the objects they represent.
+pair provide additional information particular to the objects they represent.
 
 	Eventfd files
 	~~~~~~~~~~~~~
@@ -1687,17 +1687,18 @@ pair provide additional information pecu
 
 	where 'wd' is a watch descriptor in decimal form, ie a target file
 	descriptor number, 'ino' and 'sdev' are inode and device where the
-	target file lays on and the 'mask' is the mask of events, all in hex
+	target file resides and the 'mask' is the mask of events, all in hex
 	form [see inotify(7) for more details].
 
-	In case if the kernel built with exportfs the path to the target file
-	is encoded as a file handle. The file handle provided by three fields
-	'fhandle-bytes', 'fhandle-type' and 'f_handle', all in hex format.
+	If the kernel was built with exportfs support, the path to the target
+	file is encoded as a file handle.  The file handle is provided by three
+	fields 'fhandle-bytes', 'fhandle-type' and 'f_handle', all in hex
+	format.
 
 	If the kernel is built without exportfs support the file handle won't be
 	printed out.
 
-	For fanotify files the format is the following
+	For fanotify files the format is
 
 	pos:	0
 	flags:	02
@@ -1709,9 +1710,9 @@ pair provide additional information pecu
 	flags:	02
 	fanotify mnt_id:13 mask:1 ignored_mask:40000000
 
-	where 'ino', 'sdev' are target inode and device, 'mnt_id' is the mount point identifier,
-	'mask' is the events mask used and 'ignored_mask' is the mask of events which are
-	to be ignored. All written in hex format.
+	where 'ino', 'sdev' are target inode and device, 'mnt_id' is the mount
+	point identifier, 'mask' is the events mask used and 'ignored_mask' is
+	the mask of events which are to be ignored. All in hex format.
 
 
 ------------------------------------------------------------------------------
_

