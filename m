Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992670Ab2KOBvV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 20:51:21 -0500
Received: from mail-qa0-f74.google.com ([209.85.216.74]:44737 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992613Ab2KOBvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 20:51:17 -0500
From: David Sharp <dhsharp@google.com>
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>,
        David Sharp <dhsharp@google.com>
Subject: [PATCH 2/4] kernel-shark: Allow unsetting of all CPUs in filter
Date: Wed, 14 Nov 2012 17:51:12 -0800
Message-Id: <1352944274-21699-2-git-send-email-dhsharp@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1352944274-21699-1-git-send-email-dhsharp@google.com>
References: <1352944274-21699-1-git-send-email-dhsharp@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vaibhav Nagarnaik <vnagarnaik@google.com>

The button "All CPUs" in CPU filter dialog allows setting of all CPUs
but doesn't clear CPUs when it is unchecked. Make sure that when the
"All CPUs" button is unchecked, all the CPUs get unchecked.

Tested: In kernelshark, go to Filter->list CPUs and uncheck "All CPUs"
button. All the CPUs should be unchecked at that point.

Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
Signed-off-by: David Sharp <dhsharp@google.com>
---
 trace-filter.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/trace-filter.c b/trace-filter.c
index c657a18..89cf032 100644
--- a/trace-filter.c
+++ b/trace-filter.c
@@ -1723,12 +1723,10 @@ void cpu_toggle(gpointer data, GtkWidget *widget)
 
 	if (strcmp(label, CPU_ALL_CPUS_STR) == 0) {
 		cpu_helper->allcpus = active;
-		if (active) {
-			/* enable all toggles */
-			for (cpu = 0; cpu < cpu_helper->cpus; cpu++)
-				gtk_toggle_button_set_active(GTK_TOGGLE_BUTTON(cpu_helper->buttons[cpu]),
-							     TRUE);
-		}
+		/* enable/disable all toggles */
+		for (cpu = 0; cpu < cpu_helper->cpus; cpu++)
+			gtk_toggle_button_set_active(GTK_TOGGLE_BUTTON(cpu_helper->buttons[cpu]),
+						     active ? TRUE : FALSE);
 		return;
 	}
 
-- 
1.7.7.3

