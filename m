Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412Ab0HBANz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 20:13:55 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39282 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215Ab0HBANe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 20:13:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=d1+e/+ZSeeCulSYaRCxaMjIGFq4ShKi4e1C8HnyRQ+KAtmusj0q5BT5mKylRL5oMm2
         Y37bnEfveroX0Y+8v3skpk64tdJ0Hc+0i/URcJBxQSDDCWZUXfSJvtdQef07+ADHJ/+D
         FMxWNDauA11OGr9TgQTnje5tJwXDOA+OsIoZ0=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Nikhil Rao <ncrao@google.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Tom Zanussi <tzanussi@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 06/12] perf, sched migration: Fix key bindings
Date: Mon,  2 Aug 2010 02:13:07 +0200
Message-Id: <1280707993-6599-7-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1280707993-6599-1-git-send-regression-fweisbec@gmail.com>
References: <1280707993-6599-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nikhil Rao <ncrao@google.com>

EVT_KEY_DOWN and EVT_LEFT_DOWN events are not bound to the RootFrame
event handler. As a result, zoom/scroll via keyboard events do not
work. This patch adds the missing bindings.

Signed-off-by: Nikhil Rao <ncrao@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/scripts/python/sched-migration.py |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/scripts/python/sched-migration.py b/tools/perf/scripts/python/sched-migration.py
index e9898c5..8b8fb7c 100644
--- a/tools/perf/scripts/python/sched-migration.py
+++ b/tools/perf/scripts/python/sched-migration.py
@@ -54,6 +54,8 @@ class RootFrame(wx.Frame):
 		self.scroll_panel.Bind(wx.EVT_KEY_DOWN, self.on_key_press)
 		self.scroll_panel.Bind(wx.EVT_LEFT_DOWN, self.on_mouse_down)
 		self.scroll.Bind(wx.EVT_PAINT, self.on_paint)
+		self.scroll.Bind(wx.EVT_KEY_DOWN, self.on_key_press)
+		self.scroll.Bind(wx.EVT_LEFT_DOWN, self.on_mouse_down)
 
 		self.scroll.Fit()
 		self.Fit()
-- 
1.6.2.3

