Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225Ab0G0RGW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 13:06:22 -0400
Received: from cantor.suse.de ([195.135.220.2]:44843 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772Ab0G0RGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 13:06:18 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH 3/3] bdi: Initialize noop_backing_dev_info properly
Date: Tue, 27 Jul 2010 19:05:01 +0200
Message-Id: <1280250301-17603-4-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1280250301-17603-1-git-send-email-jack@suse.cz>
References: <1280250301-17603-1-git-send-email-jack@suse.cz>
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
index 123bcef..c0f7157 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -29,6 +29,7 @@ EXPORT_SYMBOL_GPL(default_backing_dev_info);
 
 struct backing_dev_info noop_backing_dev_info = {
 	.name		= "noop",
+	.capabilities	= BDI_CAP_NO_ACCT_AND_WRITEBACK,
 };
 EXPORT_SYMBOL_GPL(noop_backing_dev_info);
 
@@ -254,6 +255,7 @@ static int __init default_bdi_init(void)
 	err = bdi_init(&default_backing_dev_info);
 	if (!err)
 		bdi_register(&default_backing_dev_info, NULL, "default");
+	err = bdi_init(&noop_backing_dev_info);
 
 	return err;
 }
-- 
1.6.4.2

