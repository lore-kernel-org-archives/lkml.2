Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab1KDJ1H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 05:27:07 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:51987 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab1KDJ1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 05:27:05 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: sergey.senozhatsky@gmail.com, bp@alien8.de
Subject: [PATCH 0/4] patches to cure race in lock_set_class()
Date: Fri,  4 Nov 2011 17:26:26 +0800
Message-Id: <1320398790-21663-1-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This a new version of my previous post[1].

patch#1 is the one which fix the reported bug.
  So Sergey, Borislav, would you please give it a test?

patch#2~4 is an enhancement which fix a potential race in
  lock_set_class(). But the fact is the only current user
  in kernel is lock_set_subclass(), we still have no
  user which change its 'key' in flying. So I mark it
  with RFC.

More detail in each patch :)

Thanks,
Yong

[1]:http://marc.info/?l=linux-kernel&m=131919035525533

Yong Zhang (4):
  lockdep: lock_set_subclass() fix
  lockdep: Let register_lock_class() can be called with/without
    graph_lock
  lockdep: split lockdep_init_map()
  lockdep: fix race condition in __lock_set_class()

 include/linux/lockdep.h |    2 +-
 kernel/lockdep.c        |   50 ++++++++++++++++++++++++++++++++--------------
 2 files changed, 36 insertions(+), 16 deletions(-)

-- 
1.7.5.4

