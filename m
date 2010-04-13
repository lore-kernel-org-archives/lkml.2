Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab0DMBVN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 21:21:13 -0400
Received: from bld-mail16.adl2.internode.on.net ([150.101.137.101]:47238 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754521Ab0DMBUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 21:20:47 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
Subject: [PATCH 0/2] Context sensitive memory shrinker support
Date: Tue, 13 Apr 2010 10:24:13 +1000
Message-Id: <1271118255-21070-1-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently I made the XFS inode reclaim operate entirely in the background for
both clean and dirty inodes as it simplified the code a lot and is somewhat
more efficient. Unfortunately, there are some workloads where the
background reclaim is not freeing memory fast enough, so the reclaim needs an
extra push when memory is low.

The inode caches are per-filesystem on XFS, so to make effective use of the
shrinker callbacks when memory is low, we need a context to be passed through
the shrinker to give us the filesystem context to run the reclaim from. The
two patches introduce the shrinker context and implement the XFS inode reclaim
shrinkers.

