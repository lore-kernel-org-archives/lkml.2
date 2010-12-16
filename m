Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368Ab0LPUxJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 15:53:09 -0500
Received: from mail-gw0-f42.google.com ([74.125.83.42]:33657 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620Ab0LPUxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 15:53:05 -0500
From: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
To: linux-kernel@vger.kernel.org, mroberto@cpti.cetuc.puc-rio.br
Cc: gregkh@suse.de, akpm@linux-foundation.org, andi@firstfloor.org
Subject: [PATCH] init: Fix for section mismatch in reference from name_to_dev_t().
Date: Thu, 16 Dec 2010 18:52:52 -0200
Message-Id: <1292532772-29923-1-git-send-email-mroberto@cpti.cetuc.puc-rio.br>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following message while compiling the kernel:

WARNING: init/mounts.o(.text+0x40): Section mismatch in reference from
the function name_to_dev_t() to the function
.init.text:devt_from_partuuid()
The function name_to_dev_t() references
the function __init devt_from_partuuid().
This is often because name_to_dev_t lacks a __init
annotation or the annotation of devt_from_partuuid is wrong.

Signed-off-by: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
---
 init/do_mounts.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/init/do_mounts.c b/init/do_mounts.c
index 830aaec..ba48e11 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -133,7 +133,7 @@ done:
  *	bangs.
  */
 
-dev_t name_to_dev_t(char *name)
+dev_t __init name_to_dev_t(char *name)
 {
 	char s[32];
 	char *p;
-- 
1.7.3.2

