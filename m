Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab0FDKZo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 06:25:44 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:41292 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960Ab0FDKZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 06:25:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=G52WH0Pw5L8zJeJ+c+8kwlaAGjyDt7HyTKBYUletPzISxpDQSd5Tbsw3Pf+grKkrCC
         c0GBV/sHJA+4mxuSPyJEMiR8He13yRopAuYDxs7D8wEGmbeaRvWxXzbNuuPPxkrySTQE
         zeCD3sGBX5FEV3SctLixfQ7kiQARu5i9yshC0=
Message-ID: <4C08D498.5090503@gmail.com>
Date: Fri, 04 Jun 2010 18:25:28 +0800
From: Wan ZongShun <mcuos.com@gmail.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH] lib: fix a memory leak risk
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The netlink_kernel_create failed will arouse memory leak,
this patch is to add the 'kfree(ue_sk)' here.

Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>

---
 lib/kobject_uevent.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
index 59c1551..08e15f7 100644
--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -378,6 +378,7 @@ static int uevent_net_init(struct net *net)
 	if (!ue_sk->sk) {
 		printk(KERN_ERR
 		       "kobject_uevent: unable to create netlink socket!\n");
+		kfree(ue_sk);
 		return -ENODEV;
 	}
 	mutex_lock(&uevent_sock_mutex);
-- 
1.6.3.3
