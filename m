Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570Ab2IGWNM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 18:13:12 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57384 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755137Ab2IGWNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 18:13:05 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, axboe@kernel.dk
Subject: [PATCH 0/2] Avoid deadlocks with bio allocation
Date: Fri,  7 Sep 2012 15:12:51 -0700
Message-Id: <1347055973-11581-1-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches were part of the block cleanups series I just sent out, but I
split them off. Nothing's changed with them lately, the last thing I added was
a bit of logic to the "punt to rescue" code to only punt bios that were
allocated from the current bio_set.

Kent Overstreet (2):
  block: Reorder struct bio_set
  block: Avoid deadlocks with bio allocation by stacking drivers

 fs/bio.c            | 87 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 include/linux/bio.h | 75 +++++++++++++++++++++++++--------------------
 2 files changed, 126 insertions(+), 36 deletions(-)

-- 
1.7.12

