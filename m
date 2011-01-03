Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488Ab1ACVWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 16:22:30 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47799 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064Ab1ACVW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 16:22:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=eHKW+PDyzPDAx2u8+1wKgaQGMTTjPO3z3++oDlD92qBqlJXP2jqcPxu/hJHzuEL8iD
         oB+p+m/wkImyzSe9ALtaiY9s66yGK8RXUNJRq80zwpmrlNCALBVgEURL1/Om+asJQz2w
         0WY31+ILetbWPoFtB+zX9YLFL7Frf/DJ2mUXY=
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH] depca: Fix section mismatch derived from depca_isa_probe()
Date: Mon,  3 Jan 2011 22:22:15 +0100
Message-Id: <1294089735-3031-1-git-send-email-sedat.dilek@gmail.com>
X-Mailer: git-send-email 1.7.4.rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the following warning:

WARNING: drivers/net/depca.o(.data+0x0): Section mismatch in reference from the variable depca_isa_driver to the function .init.text:depca_isa_probe()
The variable depca_isa_driver references
the function __init depca_isa_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

Tested with linux-next (next-20101231)

Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
---
 drivers/net/depca.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/depca.c b/drivers/net/depca.c
index 91b3846..1b48b68 100644
--- a/drivers/net/depca.c
+++ b/drivers/net/depca.c
@@ -1513,7 +1513,7 @@ static enum depca_type __init depca_shmem_probe (ulong *mem_start)
 	return adapter;
 }
 
-static int __init depca_isa_probe (struct platform_device *device)
+static int __devinit depca_isa_probe (struct platform_device *device)
 {
 	struct net_device *dev;
 	struct depca_private *lp;
-- 
1.7.4.rc0

