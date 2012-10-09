Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107Ab2JIPIy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 11:08:54 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36739 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756080Ab2JIPIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 11:08:50 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: jack@suse.cz
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH 0/6] udf: Extent cache and bunch of cleanups and other patches
Date: Wed, 10 Oct 2012 00:08:37 +0900
Message-Id: <1349795317-6317-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

This patchset implements extent caching in UDF.
While reading/writing to a file, currently, UDF reads metadata serially
which takes a lot of time depending on the number of extents present
in the file. Caching last accessd extent improves metadata read time.
Instead of reading file metadata from start, now we read from
the cached extent.

Namjae Jeon (6):
  udf: fix memory leak while allocating blocks during write
  udf: don't increment lenExtents while writing to a hole
  udf: update inode's iblock count when allocating new block
  udf: remove un-needed variable from inode_getblk
  udf: implement extent caching while reading-writing to a file
  udf: use extent cache when moving to last extent

---
1.7.9.5

