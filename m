Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197Ab1IARx3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 13:53:29 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:49118 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757144Ab1IARx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 13:53:26 -0400
From: crquan@gmail.com
To: linux-kbuild@vger.kernel.org, Arnaud Lacombe <lacombar@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Michal Marek <mmarek@suse.cz>,
        Nir Tzachar <nir.tzachar@gmail.com>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
        c.rq541@comcast.net
Subject: [PATCH V3 5/5] scripts/kconfig/nconf: add KEY_HOME / KEY_END for dialog_inputbox
Date: Thu,  1 Sep 2011 10:52:22 -0700
Message-Id: <1314899542-5848-5-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1314899542-5848-4-git-send-email-crquan@gmail.com>
References: <CAH5vBdKxbaKDrA2gAj5CoDYShN+5dnfu6Bmd=4+oV-XmnYQnFA@mail.gmail.com>
 <1314899542-5848-1-git-send-email-crquan@gmail.com>
 <1314899542-5848-2-git-send-email-crquan@gmail.com>
 <1314899542-5848-3-git-send-email-crquan@gmail.com>
 <1314899542-5848-4-git-send-email-crquan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cheng Renquan <crquan@gmail.com>

to make it easier to locate begin/end when editing long strings;

Signed-off-by: Cheng Renquan <crquan@gmail.com>
Acked By: Nir Tzachar <nir.tzachar@gmail.com>
---
 scripts/kconfig/nconf.gui.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/scripts/kconfig/nconf.gui.c b/scripts/kconfig/nconf.gui.c
index 4b9d8b6..3b18dd8 100644
--- a/scripts/kconfig/nconf.gui.c
+++ b/scripts/kconfig/nconf.gui.c
@@ -465,6 +465,14 @@ int dialog_inputbox(WINDOW *main_window,
 				cursor_form_win--;
 			}
 			break;
+		case KEY_HOME:
+			cursor_position = 0;
+			cursor_form_win = 0;
+			break;
+		case KEY_END:
+			cursor_position = len;
+			cursor_form_win = min(cursor_position, prompt_width-1);
+			break;
 		default:
 			if ((isgraph(res) || isspace(res))) {
 				/* one for new char, one for '\0' */
-- 
1.7.6

