Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337Ab2AILgq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 06:36:46 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:56284 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab2AILgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 06:36:43 -0500
From: Paulius Zaleckas <paulius.zaleckas@gmail.com>
Subject: [PATCH v2 2/2] menuconfig: add Home and End keys support for inputbox
To: mmarek@suse.cz, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 09 Jan 2012 13:36:41 +0200
Message-ID: <20120109113641.24486.95511.stgit@localhost6.localdomain6>
In-Reply-To: <20120109113633.24486.69758.stgit@localhost6.localdomain6>
References: <20120109113633.24486.69758.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Makes long string editing easier.

Signed-off-by: Paulius Zaleckas <paulius.zaleckas@gmail.com>
---

 scripts/kconfig/lxdialog/inputbox.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/scripts/kconfig/lxdialog/inputbox.c b/scripts/kconfig/lxdialog/inputbox.c
index 834eee9..0d9cacc 100644
--- a/scripts/kconfig/lxdialog/inputbox.c
+++ b/scripts/kconfig/lxdialog/inputbox.c
@@ -158,6 +158,16 @@ do_resize:
 					goto redraw;
 				}
 				continue;
+			case KEY_HOME:
+				scroll = input_x = 0;
+				goto redraw;
+			case KEY_END:
+				if (len >= box_width) {
+					scroll = len - box_width + 1;
+					input_x = box_width - 1;
+				} else
+					input_x = len;
+				goto redraw;
 			default:
 				if (key < 0x100 && isprint(key)) {
 					if (len < MAX_LEN) {

