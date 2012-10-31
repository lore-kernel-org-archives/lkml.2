Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab2JaQ7K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 12:59:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45139 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab2JaQ7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 12:59:08 -0400
From: Joonsoo Kim <js1304@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH v2 0/5] minor clean-up and optimize highmem related code
Date: Thu,  1 Nov 2012 01:56:32 +0900
Message-Id: <1351702597-10795-1-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <Yes>
References: <Yes>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset clean-up and optimize highmem related code.

Change from v1
Rebase on v3.7-rc3
[4] Instead of returning index of last flushed entry, return first index.
And update last_pkmap_nr to this index to optimize more.

Summary for v1
[1] is just clean-up and doesn't introduce any functional change.
[2-3] are for clean-up and optimization.
These eliminate an useless lock opearation and list management.
[4-5] is for optimization related to flush_all_zero_pkmaps().

Joonsoo Kim (5):
  mm, highmem: use PKMAP_NR() to calculate an index of pkmap
  mm, highmem: remove useless pool_lock
  mm, highmem: remove page_address_pool list
  mm, highmem: makes flush_all_zero_pkmaps() return index of first
    flushed entry
  mm, highmem: get virtual address of the page using PKMAP_ADDR()

 include/linux/highmem.h |    1 +
 mm/highmem.c            |  108 ++++++++++++++++++++++-------------------------
 2 files changed, 51 insertions(+), 58 deletions(-)

-- 
1.7.9.5

