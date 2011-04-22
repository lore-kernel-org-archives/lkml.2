Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780Ab1DVW0f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 18:26:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:39450 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756334Ab1DVW0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 18:26:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,256,1301900400"; 
   d="scan'208";a="682724241"
From: james_p_freyensee@linux.intel.com
To: akpm@linux-foundattion.org
Cc: rientjes@google.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        suhail.ahmed@intel.com, christophe.guerard@intel.com,
        james_p_freyensee@linux.intel.com
Subject: [PATCH] export kernel call get_task_comm().
Date: Fri, 22 Apr 2011 15:26:28 -0700
Message-Id: <1303511188-728-2-git-send-email-james_p_freyensee@linux.intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <james_p_freyensee@linux.intel.com>
References: <james_p_freyensee@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: J Freyensee <james_p_freyensee@linux.intel.com>

This allows drivers who call this function to be compiled modularly.
Otherwise, a driver who is interested in this type of functionality
has to implement their own get_task_comm() call, causing code
duplication in the Linux source tree.

Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>
---
 fs/exec.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 8328beb..e1ac338 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1004,6 +1004,7 @@ char *get_task_comm(char *buf, struct task_struct *tsk)
 	task_unlock(tsk);
 	return buf;
 }
+EXPORT_SYMBOL_GPL(get_task_comm);
 
 void set_task_comm(struct task_struct *tsk, char *buf)
 {
-- 
1.7.2.3

