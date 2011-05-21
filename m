Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598Ab1EUI5Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 04:57:24 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:44893 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753806Ab1EUI5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 04:57:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=UiOlWsAnUwlXckxqOoOw325AjMAGSwQWX+9oQlHtsD5xAFE7rj9uaY7Xab+Cj2k4MC
         64+XO02SHwbLpcLxq4WLRYPo8C/r7+fzBJkSZ/nuq9xX5NAzl1kz2h2RXK0TFwMkyK4p
         ZVdyD1wC/NTIhs2OqfADZOmYPcnsDeO3GJk2U=
From: Jim Cromie <jim.cromie@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu,
        acme@ghostprotocols.net, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 2/2] dont commify big numbers by default, let -B do it
Date: Sat, 21 May 2011 02:56:43 -0600
Message-Id: <1305968203-14240-3-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1305968203-14240-1-git-send-email-jim.cromie@gmail.com>
References: <1305968203-14240-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, big numbers get commas by default, which complicates parsing
by automation.  Turn it off by default, users can add -B.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 tools/perf/builtin-stat.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 3858573..3a703e4 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -86,7 +86,7 @@ static pid_t			target_pid			= -1;
 static pid_t			target_tid			= -1;
 static pid_t			child_pid			= -1;
 static bool			null_run			=  false;
-static bool			big_num				=  true;
+static bool			big_num				=  false;
 static int			big_num_opt			=  -1;
 static const char		*cpu_list;
 static const char		*csv_sep			= NULL;
-- 
1.7.4.1

