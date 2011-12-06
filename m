Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751551Ab1LFPs5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 10:48:57 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:44649 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846Ab1LFPs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 10:48:56 -0500
Date: Tue, 6 Dec 2011 15:48:54 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] apparmor fix for __d_path() misuse
Message-ID: <20111206154854.GH2203@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Fix for use-after-free race in apparmor d_namespace_path() and
partially sanitizing the atrocious __d_path() API that has caused that
mess in the first place.  Please, pull from
git://git.kernel.org:/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Al Viro (1):
      fix apparmor dereferencing potentially freed dentry, sanitize __d_path() API

Diffstat:
 fs/dcache.c                |   73 +++++++++++++++++++++++++++----------------
 fs/namespace.c             |   20 ++++++-----
 fs/seq_file.c              |    8 ++--
 include/linux/dcache.h     |    3 +-
 include/linux/fs.h         |    1 +
 security/apparmor/path.c   |   36 ++++++++-------------
 security/tomoyo/realpath.c |    2 +-
 7 files changed, 79 insertions(+), 64 deletions(-)
