Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab2HAR5J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 13:57:09 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58579 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754663Ab2HAR5I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 13:57:08 -0400
MIME-Version: 1.0
Date: Wed, 1 Aug 2012 20:57:07 +0300
Message-ID: <CAL7r9b39L1HuKis+PxOh9tAJ0iEwsP2c+k+=6w00JWCa=FwW5w@mail.gmail.com>
Subject: [PATCH] module: Fix compile error for ref_module when CONFIG_MODULES
 is not set
From: =?UTF-8?Q?Barbaros_Tokao=C4=9Flu?= <barbarost@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ref_module function is not defined when CONFIG_MODULES is not set thus
it causes compile error when a module which is set to be built-in uses it.
This patch defines a dummy ref_module function when CONFIG_MODULES
is not set.

Signed-off-by: Barbaros Tokaoğlu <barbarost@gmail.com>
---
 include/linux/module.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index fbcafe2..ba9a7d0 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -553,6 +553,11 @@ static inline void module_put(struct module *module)
 {
 }

+static inline int ref_module(struct module *a, struct module *b)
+{
+       return 0;
+}
+
 #define module_name(mod) "kernel"

 /* For kallsyms to ask for address resolution.  NULL means not found. */
--
1.7.5.4
