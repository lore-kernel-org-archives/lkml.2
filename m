Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760545Ab2IGLYA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 07:24:00 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:46519 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760367Ab2IGLXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 07:23:55 -0400
From: Jeff Layton <jlayton@redhat.com>
To: eparis@redhat.com, viro@zeniv.linux.org.uk
Cc: linux-audit@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, bfields@fieldses.org
Subject: [PATCH v6 00/10] audit: overhaul audit_names handling to allow for retrying on path-based syscalls
Date: Fri,  7 Sep 2012 07:23:37 -0400
Message-Id: <1347017027-17167-1-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is another minor respin of the series that I posted June
26th.

The main impetus of this series to to allow the audit_names
infrastructure to properly handle the situation where the lookup and
operation on a path-based syscall is retried.

Along with that, there are a number of bugfixes in this patch, as well
as a few minor optimizations.

This series is available via the "audit" branch of my git tree as well:

    git://git.samba.org/jlayton/linux.git audit

I'd like to see this patchset go into 3.7 if at all possible.

Eric Paris (1):
  audit: make audit_compare_dname_path use parent_len helper

Jeff Layton (9):
  audit: remove unnecessary NULL ptr checks from do_path_lookup
  audit: pass in dentry to audit_copy_inode wherever possible
  audit: no need to walk list in audit_inode if name is NULL
  audit: reverse arguments to audit_inode_child
  audit: add a new "type" field to audit_names struct
  audit: set the name_len in audit_inode for parent lookups
  audit: remove dirlen argument to audit_compare_dname_path
  audit: optimize audit_compare_dname_path
  audit: overhaul __audit_inode_child to accomodate retrying

 fs/btrfs/ioctl.c         |   2 +-
 fs/namei.c               |  22 ++++-----
 fs/open.c                |   4 +-
 fs/xattr.c               |   8 ++--
 include/linux/audit.h    |  36 +++++++++-----
 include/linux/fsnotify.h |   8 ++--
 ipc/mqueue.c             |   8 ++--
 kernel/audit.h           |   7 ++-
 kernel/audit_watch.c     |   3 +-
 kernel/auditfilter.c     |  65 +++++++++++++++++---------
 kernel/auditsc.c         | 119 +++++++++++++++++++++++++++++------------------
 11 files changed, 170 insertions(+), 112 deletions(-)

-- 
1.7.11.4

