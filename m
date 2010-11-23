Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab0KWPVz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 10:21:55 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43057 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109Ab0KWPVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 10:21:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=qPm/uCDlLcQq5l4+AlLekjU2EkqBlQnZty2ePnS/kSHv4ymqqASmpnaXUQs5yvc5mn
         V0+bjO1TsTFTqU4LscjnCgfxf/KT+o+SHxH5p0R4JdZU12A3vOYosqrEkAqLKWin8Z39
         AYU19Y2uqvCK1x3nEZm1xfhmcD+K+92fk0EXk=
From: Franck Bui-Huu <vagabon.xyz@gmail.com>
To: a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] perf: Limit event refresh to sampling event
Date: Tue, 23 Nov 2010 16:21:44 +0100
Message-Id: <1290525705-6265-2-git-send-email-fbuihuu@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1290525705-6265-1-git-send-email-fbuihuu@gmail.com>
References: <1290525705-6265-1-git-send-email-fbuihuu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Franck Bui-Huu <fbuihuu@gmail.com>

Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
---
 kernel/perf_event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index df7869f..813b09e 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1072,7 +1072,7 @@ static int perf_event_refresh(struct perf_event *event, int refresh)
 	/*
 	 * not supported on inherited events
 	 */
-	if (event->attr.inherit)
+	if (event->attr.inherit || !is_sampling_event(event))
 		return -EINVAL;
 
 	atomic_add(refresh, &event->event_limit);
-- 
1.7.3.2

