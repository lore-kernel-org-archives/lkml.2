Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab2AQMWr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 07:22:47 -0500
Received: from vms173003pub.verizon.net ([206.46.173.3]:51799 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436Ab2AQMWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 07:22:45 -0500
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 48/50] intel_idle: Fix a cast to pointer from integer of
 different size warning in intel_idle
Date: Tue, 17 Jan 2012 07:21:40 -0500
Message-id: <441f30f24edbc7ed35107472fd0be2ce86b70aee.1326802230.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.9.rc1
In-reply-to: <1326802902-21583-1-git-send-email-lenb@kernel.org>
References: <1326802902-21583-1-git-send-email-lenb@kernel.org>
In-reply-to: <553575f1ae048aa44682b46b3c51929a0b3ad337.1326802228.git.len.brown@intel.com>
References: <553575f1ae048aa44682b46b3c51929a0b3ad337.1326802228.git.len.brown@intel.com>
Reply-to: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

Fix the following warning:

drivers/idle/intel_idle.c: In function 'intel_idle_cpuidle_devices_init':
drivers/idle/intel_idle.c:518:5: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]

By making get_driver_data() return a long instead of an int.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/idle/intel_idle.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 27e41cc..6a3d91d 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -197,7 +197,7 @@ static struct cpuidle_state atom_cstates[MWAIT_MAX_NUM_CSTATES] = {
 		.enter = &intel_idle },
 };
 
-static int get_driver_data(int cstate)
+static long get_driver_data(int cstate)
 {
 	int driver_data;
 	switch (cstate) {
-- 
1.7.9.rc1

