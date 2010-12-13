Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619Ab0LMBXq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 20:23:46 -0500
Received: from bld-mail20.adl6.internode.on.net ([150.101.137.105]:47232 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752291Ab0LMBXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 20:23:45 -0500
From: Dave Chinner <david@fromorbit.com>
To: xfs@oss.sgi.com
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl
Subject: [PATCH 0/3] Use generic percpu counters in XFS V2
Date: Mon, 13 Dec 2010 12:21:50 +1100
Message-Id: <1292203313-15570-1-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series replaces the XFS per-cpu superblock counters with
generic per-cpu counters. It adds a specialised operation to the
generic counter implementation and then switches the XFS percpu
superblock counters over to use the generic percpu counter
implementation. The result is several hundred lines of complex code
removed from XFS.

Version 2:
- use wrappers for percpu_counter_add_unless_lt() to allow custom
  batch sizes to be used.
- removed xfs_icsb_*() wrappers from percpu counters.
- cleaned up split of xfs_icsb_modify_counters().

