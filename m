Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932736Ab2AEQJ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 11:09:27 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49357 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932726Ab2AEQJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 11:09:01 -0500
From: Paulius Zaleckas <paulius.zaleckas@gmail.com>
Subject: [PATCH 2/2] menuconfig: add Home and End keys support for inputbox
To: mmarek@suse.cz, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 05 Jan 2012 18:08:59 +0200
Message-ID: <20120105160859.7543.67706.stgit@localhost6.localdomain6>
In-Reply-To: <20120105160852.7543.76603.stgit@localhost6.localdomain6>
References: <20120105160852.7543.76603.stgit@localhost6.localdomain6>
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
index 3bd7111..ad31bec 100644
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
 					if (scroll + input_x < MAX_LEN) {

