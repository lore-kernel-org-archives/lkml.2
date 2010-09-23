Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568Ab0IWUQM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 16:16:12 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:36509 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756553Ab0IWUQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 16:16:10 -0400
Date: Thu, 23 Sep 2010 22:19:01 +0200
From: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
To: acme@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [patch 36-rc5] perf browser ui segfault on 'a' for annotate
Message-ID: <20100923201901.GE31726@gambetta>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

There a typo in util/ui/browsers/hists.c that leads to a segfault when
you press the 'a' key on a non-resolved symbol (plain hex address).

This is fixed by the patch below.

Thanks,
Frederik

Signed-off-by: Frederik Deweerdt <frederik.deweerdt@xprog.eu>

diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index dafdf67..6866aa4 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -773,7 +773,7 @@ int hists__browse(struct hists *self, const char *helpline, const char *ev_name)
 
 			switch (key) {
 			case 'a':
-				if (browser->selection->map == NULL &&
+				if (browser->selection->map == NULL ||
 				    browser->selection->map->dso->annotate_warned)
 					continue;
 				goto do_annotate;
