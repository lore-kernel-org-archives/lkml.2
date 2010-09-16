Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978Ab0IPWpT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 18:45:19 -0400
Received: from cantor.suse.de ([195.135.220.2]:60709 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754913Ab0IPWpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 18:45:15 -0400
From: Jan Kara <jack@suse.cz>
To: Jens@suse.cz, "Axboe <axboe"@kernel.dk
Cc: Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: [PATCH 1/3] bdi: Initialize noop_backing_dev_info properly
Date: Fri, 17 Sep 2010 00:44:09 +0200
Message-Id: <1284677051-28564-2-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1284677051-28564-1-git-send-email-jack@suse.cz>
References: <1284677051-28564-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Properly initialize this backing dev info so that writeback code does not
barf when getting to it e.g. via sb->s_bdi.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 mm/backing-dev.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index eaa4a5b..69ae8ca 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -30,6 +30,7 @@ EXPORT_SYMBOL_GPL(default_backing_dev_info);
 
 struct backing_dev_info noop_backing_dev_info = {
 	.name		= "noop",
+	.capabilities	= BDI_CAP_NO_ACCT_AND_WRITEBACK,
 };
 EXPORT_SYMBOL_GPL(noop_backing_dev_info);
 
@@ -243,6 +244,7 @@ static int __init default_bdi_init(void)
 	err = bdi_init(&default_backing_dev_info);
 	if (!err)
 		bdi_register(&default_backing_dev_info, NULL, "default");
+	err = bdi_init(&noop_backing_dev_info);
 
 	return err;
 }
-- 
1.6.4.2

