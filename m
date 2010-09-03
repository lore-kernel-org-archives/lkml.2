Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867Ab0ICNlv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 09:41:51 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:58587 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308Ab0ICNlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 09:41:50 -0400
Message-Id: <20100903134116.039612691@szeredi.hu>
User-Agent: quilt/0.46-1
Date: Fri, 03 Sep 2010 15:41:16 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: vaurora@redhat.com, neilb@suse.de, viro@zeniv.linux.org.uk
Subject: [PATCH 0/6] overlay filesystem prototype
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated patches follow.

Changes since the last version:

 - rename "hybrid union filesystem" to "overlay filesystem" or overlayfs

 - added documentation written by Neil

 - correct st_dev for directories (reported by Neil)

 - use getattr() to get attributes from the underlying filesystems,
   this means that now an overlay filesystem itself can be the lower,
   read-only layer of another overlay

 - listxattr filters out private extended attributes

 - get write ref on the upper layer on mount unless the overlay
   itself is mounted read-only

 - raise capabilities for copy up, dealing with whiteouts and opaque
   directories.  Now the overlay works for non-root users as well

 - "rm -rf" didn't work correctly in all cases if the directory was
   copied up between opendir and the first readdir, this is now fixed
   (and the directory operations consolidated)

 - simplified copy up, this broke optimization for truncate and
   open(O_TRUNC) (now file is copied up to be immediately truncated,
   will fix)

 - st_nlink for merged directories set to 1, this is an "illegal"
   value that normal filesystems never have but some use it to
   indicate that the number of subdirectories is unknown.  Utilities
   (find, ...) seem to tolerate this well.

 - misc fixes I forgot about

Git tree is here:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs

Thanks,
Miklos
