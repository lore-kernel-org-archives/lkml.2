Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967421Ab0GTAq4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 20:46:56 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:13666 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967248Ab0GTAqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 20:46:55 -0400
From: David Daney <ddaney@caviumnetworks.com>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, David Daney <ddaney@caviumnetworks.com>
Subject: [PATCH 2/2] trace-cmd: Don't SIGSEGV in trace-graph.c:load_handle
Date: Mon, 19 Jul 2010 17:46:50 -0700
Message-Id: <1279586810-29859-3-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1279586810-29859-1-git-send-email-ddaney@caviumnetworks.com>
References: <1279586810-29859-1-git-send-email-ddaney@caviumnetworks.com>
X-OriginalArrivalTime: 20 Jul 2010 00:46:54.0997 (UTC) FILETIME=[0CEA7450:01CB27A5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This 'fixes' another crash I encountered.  Don't try to dereference
NULL records.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
---
 trace-graph.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/trace-graph.c b/trace-graph.c
index f940874..a53ab84 100644
--- a/trace-graph.c
+++ b/trace-graph.c
@@ -2413,6 +2413,8 @@ static int load_handle(struct graph_info *ginfo,
 
 		free_record(record);
 		record = tracecmd_read_cpu_last(handle, cpu);
+		if (!record)
+			continue;
 
 		if (record->ts > ginfo->end_time)
 			ginfo->end_time = record->ts;
-- 
1.7.1.1

