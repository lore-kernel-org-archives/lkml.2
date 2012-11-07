Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab2KGIkX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 03:40:23 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:65471 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab2KGIkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 03:40:21 -0500
From: Sha Zhengju <handai.szj@gmail.com>
To: linux-mm@kvack.org, cgroups@vger.kernel.org, mhocko@suse.cz,
        kamezawa.hiroyu@jp.fujitsu.com, akpm@linux-foundation.org,
        rientjes@google.com
Cc: linux-kernel@vger.kernel.org, Sha Zhengju <handai.szj@taobao.com>
Subject: [PATCH V2 0/2] Provide more precise dump info for memcg-oom
Date: Wed,  7 Nov 2012 16:40:02 +0800
Message-Id: <1352277602-21687-1-git-send-email-handai.szj@taobao.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sha Zhengju <handai.szj@taobao.com>


When memcg oom is happening the current memcg related dump information
is limited for debugging. The patches provide more detailed memcg page statistics
and also take hierarchy into consideration.
The previous primitive version can be reached here: https://lkml.org/lkml/2012/7/30/179.

Change log:
	1. some modification towards hierarchy
	2. rework dump_tasks
	3. rebased on Michal's mm tree since-3.6  

Any comments are welcomed. : )


Sha Zhengju (2):
	memcg-oom-provide-more-precise-dump-info-while-memcg.patch
	oom-rework-dump_tasks-to-optimize-memcg-oom-situatio.patch

 include/linux/memcontrol.h |    7 ++++
 include/linux/oom.h        |    2 +
 mm/memcontrol.c            |   85 +++++++++++++++++++++++++++++++++++++++-----
 mm/oom_kill.c              |   61 +++++++++++++++++++------------
 4 files changed, 122 insertions(+), 33 deletions(-)
