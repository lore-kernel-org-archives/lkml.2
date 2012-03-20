Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757902Ab2CTMav (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 08:30:51 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:51305 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607Ab2CTMau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 08:30:50 -0400
MIME-Version: 1.0
Date: Tue, 20 Mar 2012 20:30:48 +0800
Message-ID: <CAJd=RBAjXi04AwyCS94xFZkKNWv3ngKw=04Jw+Y9nNnMXjH-WQ@mail.gmail.com>
Subject: [PATCH] autonuma: release page_table_lock in scanning pmd
From: Hillf Danton <dhillf@gmail.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only for unlikely corner case, unlock is added to pair lock.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/mm/autonuma.c	Sat Mar 17 11:01:50 2012
+++ b/mm/autonuma.c	Tue Mar 20 19:58:44 2012
@@ -522,7 +522,8 @@ static int knumad_scan_pmd(struct mm_str
 				spin_unlock(&mm->page_table_lock);
 				goto out;
 			}
-		}
+		} else
+			spin_unlock(&mm->page_table_lock);
 	}

 	VM_BUG_ON(!pmd_present(*pmd));
--
