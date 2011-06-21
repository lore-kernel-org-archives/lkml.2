Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351Ab1FUJzg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 05:55:36 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64880 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756135Ab1FUJzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 05:55:35 -0400
MIME-Version: 1.0
X-Originating-IP: [87.194.181.195]
Date: Tue, 21 Jun 2011 10:55:34 +0100
Message-ID: <BANLkTikMc1WfJMJ2NeBr1E62dGjCj1Cd_w@mail.gmail.com>
Subject: [PATCH] cb710: fix #ifdef HAVE_EFFICIENT_UNALIGNED_ACCESS
From: James Hogan <james@albanarts.com>
To: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HAVE_EFFICIENT_UNALIGNED_ACCESS is a config option, therefore it needs
the CONFIG_ before it when used by the preprocessor.

Signed-off-by: James Hogan <james@albanarts.com>
---
 drivers/misc/cb710/sgbuf2.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/cb710/sgbuf2.c b/drivers/misc/cb710/sgbuf2.c
index d019746..2a40d0e 100644
--- a/drivers/misc/cb710/sgbuf2.c
+++ b/drivers/misc/cb710/sgbuf2.c
@@ -47,7 +47,7 @@ static uint32_t sg_dwiter_read_buffer(struct
sg_mapping_iter *miter)

 static inline bool needs_unaligned_copy(const void *ptr)
 {
-#ifdef HAVE_EFFICIENT_UNALIGNED_ACCESS
+#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
 	return false;
 #else
 	return ((ptr - NULL) & 3) != 0;
-- 
1.7.2.3
