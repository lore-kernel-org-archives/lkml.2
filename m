Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508Ab2D0M2U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 08:28:20 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:51690 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754237Ab2D0M2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 08:28:18 -0400
From: Rajendra Nayak <rnayak@ti.com>
To: <mturquette@ti.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Rajendra Nayak <rnayak@ti.com>
Subject: [PATCH] clk: constify parent name arrays in macros
Date: Fri, 27 Apr 2012 17:58:13 +0530
Message-ID: <1335529693-14280-1-git-send-email-rnayak@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

parent name array is now expected to be const char *, make
the relevent changes in the clk macros which define
default clock types.

Signed-off-by: Rajendra Nayak <rnayak@ti.com>
---
 include/linux/clk-private.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/clk-private.h b/include/linux/clk-private.h
index eeae7a3..6ebec83 100644
--- a/include/linux/clk-private.h
+++ b/include/linux/clk-private.h
@@ -70,7 +70,7 @@ struct clk {
 #define DEFINE_CLK_FIXED_RATE(_name, _flags, _rate,		\
 				_fixed_rate_flags)		\
 	static struct clk _name;				\
-	static char *_name##_parent_names[] = {};		\
+	static const char *_name##_parent_names[] = {};		\
 	static struct clk_fixed_rate _name##_hw = {		\
 		.hw = {						\
 			.clk = &_name,				\
@@ -85,7 +85,7 @@ struct clk {
 				_flags, _reg, _bit_idx,		\
 				_gate_flags, _lock)		\
 	static struct clk _name;				\
-	static char *_name##_parent_names[] = {			\
+	static const char *_name##_parent_names[] = {		\
 		_parent_name,					\
 	};							\
 	static struct clk *_name##_parents[] = {		\
@@ -107,7 +107,7 @@ struct clk {
 				_flags, _reg, _shift, _width,	\
 				_divider_flags, _lock)		\
 	static struct clk _name;				\
-	static char *_name##_parent_names[] = {			\
+	static const char *_name##_parent_names[] = {		\
 		_parent_name,					\
 	};							\
 	static struct clk *_name##_parents[] = {		\
-- 
1.7.1

