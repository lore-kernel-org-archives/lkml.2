Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655Ab2HMOFS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 10:05:18 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46675 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586Ab2HMOFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 10:05:16 -0400
Date: Mon, 13 Aug 2012 18:02:32 +0800
From: Wang YanQing <udknight@gmail.com>
To: FlorianSchandinat@gmx.de
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        spock@gentoo.org
Subject: [PATCH] video:uvesafb: check the return value of kzalloc
Message-ID: <20120813100232.GA16363@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	FlorianSchandinat@gmx.de, linux-fbdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, spock@gentoo.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Michal maybe forgot it merely, we should add code
to check the return value of kzalloc to make the
code more robust.

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 drivers/video/uvesafb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/video/uvesafb.c b/drivers/video/uvesafb.c
index b0e2a42..2f8f82d 100644
--- a/drivers/video/uvesafb.c
+++ b/drivers/video/uvesafb.c
@@ -659,6 +659,8 @@ static int __devinit uvesafb_vbe_getedid(struct uvesafb_ktask *task,
 	task->t.flags = TF_BUF_RET | TF_BUF_ESDI;
 	task->t.buf_len = EDID_LENGTH;
 	task->buf = kzalloc(EDID_LENGTH, GFP_KERNEL);
+	if (!task->buf)
+		return -ENOMEM;
 
 	err = uvesafb_exec(task);
 
-- 
1.7.11.1.116.g8228a23
