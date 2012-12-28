Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab2L1U2T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 15:28:19 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:46300 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab2L1U2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 15:28:17 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-parisc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] parisc: Remove obsolete regs parameter from do_execve() in hpux_execve()
Date: Fri, 28 Dec 2012 21:28:09 +0100
Message-Id: <1356726489-27229-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit da3d4c5fa56236dd924d77ffc4f982356816b93b ("get rid of pt_regs
argument of do_execve()") removed the parameter, but forgot to update
hpux_execve():

arch/parisc/hpux/fs.c: In function 'hpux_execve':
arch/parisc/hpux/fs.c:47:6: error: too many arguments to function 'do_execve'

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
http://kisskb.ellerman.id.au/kisskb/buildresult/7864854/

 arch/parisc/hpux/fs.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/parisc/hpux/fs.c b/arch/parisc/hpux/fs.c
index a0760b8..838b479 100644
--- a/arch/parisc/hpux/fs.c
+++ b/arch/parisc/hpux/fs.c
@@ -43,8 +43,7 @@ int hpux_execve(struct pt_regs *regs)
 
 	error = do_execve(filename->name,
 			  (const char __user *const __user *) regs->gr[25],
-			  (const char __user *const __user *) regs->gr[24],
-			  regs);
+			  (const char __user *const __user *) regs->gr[24]);
 
 	putname(filename);
 
-- 
1.7.0.4

