Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393Ab2F1KzR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 06:55:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40293 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab2F1KzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 06:55:15 -0400
From: Sha Zhengju <handai.szj@gmail.com>
To: linux-mm@kvack.org, cgroups@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, gthelen@google.com, yinghan@google.com,
        akpm@linux-foundation.org, mhocko@suse.cz,
        linux-kernel@vger.kernel.org, Sha Zhengju <handai.szj@taobao.com>
Subject: [PATCH 0/7] Per-cgroup page stat accounting
Date: Thu, 28 Jun 2012 18:54:45 +0800
Message-Id: <1340880885-5427-1-git-send-email-handai.szj@taobao.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series provide the ability for each memory cgroup to have independent
dirty/writeback page stats. This can provide some information for per-cgroup direct
reclaim. Meanwhile, we add more detailed dump messages for memcg OOMs.

Three features are included in this patch series:
 (0).prepare patches for page accounting
  1. memcg dirty page accounting
  2. memcg writeback page accounting
  3. memcg OOMs dump info

In (0) prepare patches, we have reworked vfs set page dirty routines to make "modify
page info" and "dirty page accouting" stay in one function as much as possible for
the sake of memcg bigger lock.

These patches are cooked based on Andrew's akpm tree.

Sha Zhengju (7):
	memcg-update-cgroup-memory-document.patch
	memcg-remove-MEMCG_NR_FILE_MAPPED.patch
	Make-TestSetPageDirty-and-dirty-page-accounting-in-o.patch
	Use-vfs-__set_page_dirty-interface-instead-of-doing-.patch
	memcg-add-per-cgroup-dirty-pages-accounting.patch
	memcg-add-per-cgroup-writeback-pages-accounting.patch
	memcg-print-more-detailed-info-while-memcg-oom-happe.patch	

 Documentation/cgroups/memory.txt |    2 +
 fs/buffer.c                      |   36 +++++++++-----
 fs/ceph/addr.c                   |   20 +-------
 include/linux/buffer_head.h      |    2 +
 include/linux/memcontrol.h       |   27 +++++++---
 mm/filemap.c                     |    5 ++
 mm/memcontrol.c                  |   99 +++++++++++++++++++++++--------------
 mm/page-writeback.c              |   42 ++++++++++++++--
 mm/rmap.c                        |    4 +-
 mm/truncate.c                    |    6 ++
 10 files changed, 159 insertions(+), 84 deletions(-)

