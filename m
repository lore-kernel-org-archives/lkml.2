Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758763Ab0I0CMg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 22:12:36 -0400
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:49674 "EHLO
	qmta04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758099Ab0I0CMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 22:12:35 -0400
From: matt mooney <mfm@muteddisk.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] kbuild: remove duplicate -I flag in addtree
Date: Sun, 26 Sep 2010 19:11:12 -0700
Message-Id: <1285553472-924-1-git-send-email-mfm@muteddisk.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When O= is used, any -I flag given that is not an absolute path gets
duplicated. The $(1) appended to the conditional clause covers the
absolute case, but due to being outside of the conditional statement
it gets added everytime.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 scripts/Kbuild.include |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
index ed2773e..08c74ed 100644
--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -158,7 +158,7 @@ modbuiltin := -f $(if $(KBUILD_SRC),$(srctree)/)scripts/Makefile.modbuiltin obj
 # Prefix -I with $(srctree) if it is not an absolute path.
 # skip if -I has no parameter
 addtree = $(if $(patsubst -I%,%,$(1)), \
-$(if $(filter-out -I/%,$(1)),$(patsubst -I%,-I$(srctree)/%,$(1))) $(1))
+$(if $(filter-out -I/%,$(1)),$(patsubst -I%,-I$(srctree)/%,$(1)),$(1)))
 
 # Find all -I options and call addtree
 flags = $(foreach o,$($(1)),$(if $(filter -I%,$(o)),$(call addtree,$(o)),$(o)))
-- 
1.7.2.1

