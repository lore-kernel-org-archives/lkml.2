Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476Ab2J1TPJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 15:15:09 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:60478 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab2J1TPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 15:15:07 -0400
From: Joonsoo Kim <js1304@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH 0/5] minor clean-up and optimize highmem related code
Date: Mon, 29 Oct 2012 04:12:51 +0900
Message-Id: <1351451576-2611-1-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <Yes>
References: <Yes>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset clean-up and optimize highmem related code.

[1] is just clean-up and doesn't introduce any functional change.
[2-3] are for clean-up and optimization.
These eliminate an useless lock opearation and list management.
[4-5] is for optimization related to flush_all_zero_pkmaps().

Joonsoo Kim (5):
  mm, highmem: use PKMAP_NR() to calculate an index of pkmap
  mm, highmem: remove useless pool_lock
  mm, highmem: remove page_address_pool list
  mm, highmem: makes flush_all_zero_pkmaps() return index of last
    flushed entry
  mm, highmem: get virtual address of the page using PKMAP_ADDR()

 include/linux/highmem.h |    1 +
 mm/highmem.c            |  102 ++++++++++++++++++++---------------------------
 2 files changed, 45 insertions(+), 58 deletions(-)

-- 
1.7.9.5

