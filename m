Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986Ab2GaSFA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 14:05:00 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34574 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710Ab2GaSE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 14:04:59 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: torvalds@linux-foundation.org
Cc: tj@kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, paul.gortmaker@windriver.com,
        Sasha Levin <levinsasha928@gmail.com>
Subject: [RFC 0/4] generic hashtable implementation
Date: Tue, 31 Jul 2012 20:05:16 +0200
Message-Id: <1343757920-19713-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are quite a few places in the kernel which implement a hashtable
in a very similar way. Instead of having implementations of a hashtable
all over the kernel, we can re-use the code.

This patch series introduces a very simple hashtable implementation, and
modifies three (random) modules to use it. I've limited it to 3 only
so that it would be easy to review and modify, and to show that even
at this number we already eliminate a big amount of duplicated code.

If this basic hashtable looks ok, future code will include:

 - RCU support
 - Self locking (list_bl?)
 - Converting more code to use the hashtable


Sasha Levin (4):
  hashtable: introduce a small and naive hashtable
  user_ns: use new hashtable implementation
  mm,ksm: use new hashtable implementation
  workqueue: use new hashtable implementation

 include/linux/hashtable.h      |   46 ++++++++++++++++++++
 include/linux/user_namespace.h |   11 +++--
 kernel/user.c                  |   54 ++++-------------------
 kernel/user_namespace.c        |    4 +-
 kernel/workqueue.c             |   91 ++++++---------------------------------
 mm/ksm.c                       |   29 ++++---------
 6 files changed, 87 insertions(+), 148 deletions(-)
 create mode 100644 include/linux/hashtable.h

-- 
1.7.8.6

