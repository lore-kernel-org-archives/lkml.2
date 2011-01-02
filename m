Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815Ab1ABHdW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:33:22 -0500
Received: from mail.windriver.com ([147.11.1.11]:37122 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754866Ab1ABHZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:25:39 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Nicolas Kaiser <nikai@nikai.net>,
        Jens Axboe <jaxboe@fusionio.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 239/260] pipe: fix failure to return error code on ->confirm()
Date: Sun,  2 Jan 2011 02:18:55 -0500
Message-Id: <1293952756-15010-240-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:24:31.0105 (UTC) FILETIME=[18D62710:01CBAA4E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Kaiser <nikai@nikai.net>

commit e5953cbdff26f7cbae7eff30cd9b18c4e19b7594 upstream.

The arguments were transposed, we want to assign the error code to
'ret', which is being returned.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/pipe.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/pipe.c b/fs/pipe.c
index 37ba29f..8087027 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -363,7 +363,7 @@ pipe_read(struct kiocb *iocb, const struct iovec *_iov,
 			error = ops->confirm(pipe, buf);
 			if (error) {
 				if (!ret)
-					error = ret;
+					ret = error;
 				break;
 			}
 
-- 
1.7.3.3

