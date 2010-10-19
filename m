Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab0JSP4E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 11:56:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:56243 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753667Ab0JSP4C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 11:56:02 -0400
Message-ID: <4CBDBF8A.8010106@kernel.org>
Date: Tue, 19 Oct 2010 17:55:54 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH v2.6.36-rc7] cifs: cancel_delayed_work() + flush_scheduled_work()
 -> cancel_delayed_work_sync()
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 19 Oct 2010 15:56:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

flush_scheduled_work() is going away.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/cifs/cifs_dfs_ref.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: work/fs/cifs/cifs_dfs_ref.c
===================================================================
--- work.orig/fs/cifs/cifs_dfs_ref.c
+++ work/fs/cifs/cifs_dfs_ref.c
@@ -44,8 +44,7 @@ static void cifs_dfs_expire_automounts(s
 void cifs_dfs_release_automount_timer(void)
 {
 	BUG_ON(!list_empty(&cifs_dfs_automount_list));
-	cancel_delayed_work(&cifs_dfs_automount_task);
-	flush_scheduled_work();
+	cancel_delayed_work_sync(&cifs_dfs_automount_task);
 }

 /**
