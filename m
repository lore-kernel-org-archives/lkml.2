Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772Ab1LaAd5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Dec 2011 19:33:57 -0500
Received: from alcazar.beanwood.com ([70.85.129.230]:55037 "EHLO
	alcazar.beanwood.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449Ab1LaAdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Dec 2011 19:33:55 -0500
X-Greylist: delayed 408 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Dec 2011 19:33:55 EST
From: Andrew Ayer <agwa@andrewayer.name>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] vfs: POSIX-compliant version of fchmodat with flag argument
Date: Fri, 30 Dec 2011 16:26:49 -0800
Message-Id: <1325291211-30354-1-git-send-email-agwa@andrewayer.name>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The below patches implement a 4 argument version of fchmodat (fchmodat4)
that supports a flag argument, as specified by POSIX.  Currently, the
glibc wrapper has a flag argument, but fails with EOPNOTSUPP if you
specify AT_SYMLINK_NOFOLLOW. POSIX says that fchmodat should only fail
with EOPNOTSUPP if you specify AT_SYMLINK_NOFOLLOW and the path actually
refers to a symbolic link (and the system doesn't support changing the
mode of symbolic links).  Unfortunately glibc can't do better because
the current syscall doesn't have a flag argument.

In addition to supporting AT_SYMLINK_NOFOLLOW, this also supports the
AT_EMPTY_PATH flag, just like fchownat.

Besides the POSIX-compliance, this patch will make it possible to
ensure, in a race-free way, that you do not follow symlinks when
chmodding. Previously, you could open a file with O_NOFOLLOW and fchmod
it, but this only worked if you had read or write permissions on the
file.  Now you can open the file with O_PATH|O_NOFOLLOW and do fchmodat
with AT_EMPTY_PATH.

Any feedback is welcome.

Cheers, 
Andrew

