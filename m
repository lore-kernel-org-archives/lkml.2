Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab0GMJfv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 05:35:51 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52592 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab0GMJfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 05:35:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=x7Yf/gHci3VnfDmxOCqemZ426yOXa4v0f3OMyTXVh2m1Bcim1C+fjb0QEuvj70kc8R
         i6Kb/dHkO4ijLxSgdpL3XgQGr4cUaLPfNYPHV1o0gjZJAn0uO+/PgXR9eruixrSx3Sun
         8dv4LHHLtjw0N9XXLQfXFVArFNmTYQ89xGKzc=
From: Martin Jansa <martin.jansa@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>, Martin Jansa <Martin.Jansa@gmail.com>
Subject: [PATCH] kbuild: setlocalversion should respect srctree param when looking for auto.conf
Date: Tue, 13 Jul 2010 11:34:36 +0200
Message-Id: <1279013676-23887-1-git-send-email-Martin.Jansa@gmail.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* it works properly only when CWD == scrtree
* with this patch:
  jama src # /usr/src/linux/scripts/setlocalversion /usr/src/linux
  -JaMa-00001-g18672de
* without:
  jama src # /usr/src/linux/scripts/setlocalversion /usr/src/linux
  Error: kernelrelease not valid - run 'make prepare' to update it

Signed-off-by: Martin Jansa <Martin.Jansa@gmail.com>
---
 scripts/setlocalversion |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/setlocalversion b/scripts/setlocalversion
index d6a866e..41864d1 100755
--- a/scripts/setlocalversion
+++ b/scripts/setlocalversion
@@ -135,7 +135,7 @@ if $scm_only; then
 	exit
 fi
 
-if test -e include/config/auto.conf; then
+if test -e "${srctree}/include/config/auto.conf"; then
 	source "$_"
 else
 	echo "Error: kernelrelease not valid - run 'make prepare' to update it"
-- 
1.7.1.1

