Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab0E0Mwr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 08:52:47 -0400
Received: from smtp-out.google.com ([216.239.44.51]:17565 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620Ab0E0Mwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 08:52:45 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:from:date:to:reply-to:cc:subject:x-system-of-record;
	b=Zaxo5iMpxLv6xMQMPT3D8BHNNwwSkM/pehEyLKB72PIur0rH82WPXqLXu8m2RQf/s
	Ru+Mk/gqyPgKTUtvZkkIQ==
Message-ID: <4bfe6b18.914ed80a.0573.4c6e@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Thu, 27 May 2010 14:50:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       fweisbec@gmail.com, acme@infradead.org, perfmon2-devel@lists.sf.net,
       eranian@gmail.com, eranian@google.com
Subject: [PATCH] perf: fix use_browser infinite loop bug in annotate
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes an infinite loop problem with perf annotate when
the TUI is not used. When the perfconfig file is not found use_browser
remains at -1, when found and tui is disabled use_browser = 0. Thus the
correct test for TUI is use_browser > 0.

Signed-off-by: Stephane Eranian <eranian@google.com>

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 08278ed..96db524 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -343,7 +343,7 @@ find_next:
 			continue;
 		}
 
-		if (use_browser) {
+		if (use_browser > 0) {
 			key = hist_entry__tui_annotate(he);
 			if (is_exit_key(key))
 				break;
