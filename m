Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977Ab1KURdS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 12:33:18 -0500
Received: from cobra.newdream.net ([66.33.216.30]:54864 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab1KURdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 12:33:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=newdream.net; h=date:from:to:cc
	:subject:message-id:mime-version:content-type; q=dns; s=
	newdream.net; b=23hPWP6idQXgAuNJVcsggqTknOM8Xb/OqL9EAOMuCb480PxD
	CKU6qQoWG+p5TgOw+/jfWNQ6br0S2NnJB+ijjfPJSs4CWmLY6kXT18bynJGpLm/e
	MsP7bAoD2a1MQVfTvt71BQAi3Zl7b0LlLgKY1UpXvf6cBMmVtFBYQGeQvbw=
Date: Mon, 21 Nov 2011 09:33:16 -0800 (PST)
From: Sage Weil <sage@newdream.net>
To: torvalds@linux-foundation.org
cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for -rc3
Message-ID: <Pine.LNX.4.64.1111210931230.6600@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following Ceph fixes from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

There is a fixed race when work queueing and inode refs, a nasty oversight 
with the root dentry being uninitialized, and a fix for the oid buffer 
size to allow RBD images with long names.

Thanks!
sage



Sage Weil (2):
      ceph: fix iput race when queueing inode work
      ceph: initialize root dentry

Stratos Psomadakis (1):
      libceph: Allocate larger oid buffer in request msgs

 fs/ceph/dir.c                   |    2 +-
 fs/ceph/inode.c                 |    9 ++++++---
 fs/ceph/super.c                 |    6 ++++--
 include/linux/ceph/osd_client.h |    8 +++++++-
 net/ceph/osd_client.c           |    2 +-
 5 files changed, 19 insertions(+), 8 deletions(-)
