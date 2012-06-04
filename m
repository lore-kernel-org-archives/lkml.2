Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab2FDHVN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 03:21:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63360 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131Ab2FDHVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 03:21:12 -0400
Date: Mon, 4 Jun 2012 16:21:00 +0900
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Sasha Levin <levinsasha928@gmail.com>
Subject: [GIT PULL] cgroup fixes for v3.5-rc1
Message-ID: <20120604072100.GB2843@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Please pull from the following branch to receive fix for the possible
premature superblock release on umount bug mentioned during v3.5-rc1
pull request.

Originally, cgroup dentry destruction path assumed that cgroup dentry
didn't have any reference left after cgroup removal thus put super
during dentry removal.  Now that there can be lingering dentry
references, this led to super being put with live dentries.  This
patch fixes the problem by putting super ref on dentry release instead
of removal.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.5-fixes

Tejun Heo (1):
      cgroup: superblock can't be released with active dentries

 kernel/cgroup.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

Thanks.

--
tejun
