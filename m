Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932106Ab1BXSHb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 13:07:31 -0500
Received: from mga11.intel.com ([192.55.52.93]:59766 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754865Ab1BXSHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 13:07:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,219,1297065600"; 
   d="scan'208";a="661150156"
From: james_p_freyensee@linux.intel.com
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, suhail.ahmed@intel.com,
        james_p_freyensee@linux.intel.com, christophe.guerard@intel.com
Subject: [PATCH 01/10] export kernel call get_task_comm().
Date: Thu, 24 Feb 2011 10:06:55 -0800
Message-Id: <1298570824-26085-2-git-send-email-james_p_freyensee@linux.intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <james_p_freyensee@linux.intel.com>
References: <james_p_freyensee@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: J Freyensee <james_p_freyensee@linux.intel.com>

This allows drivers who call this function to be compiled modularly.
Otherwise, a driver who is interested in this type of functionality
has to implement their own.

Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>
---
 fs/exec.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index c62efcb..7b209f9 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -998,6 +998,7 @@ char *get_task_comm(char *buf, struct task_struct *tsk)
 	task_unlock(tsk);
 	return buf;
 }
+EXPORT_SYMBOL_GPL(get_task_comm);
 
 void set_task_comm(struct task_struct *tsk, char *buf)
 {
-- 
1.7.2.3

