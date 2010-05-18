Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051Ab0ERGZq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 02:25:46 -0400
Received: from mail-pz0-f194.google.com ([209.85.222.194]:36479 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab0ERGZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 02:25:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=ufh7+ePH5cBtEcFq6/PQ5eOZq2xXSd9pedGOOjEyw1ILUWQ+EqkYwM4WaIwB/g82/I
         ofLQaqS70xYnguvVq792Hh1Pqg+FjBkGSbyBRrDvzsinnQME3CpNjuLIvy5Aik5UBv3y
         mvKiyRgwq5DP4Dgp4d8ETNKaIp4y1Lqswjpd0=
MIME-Version: 1.0
Date: Tue, 18 May 2010 14:25:44 +0800
Message-ID: <AANLkTiknP0na-SILHs9Zg3HzgC7XuDx4x0J8fK6RoDE4@mail.gmail.com>
Subject: [PATCH] cris:Check kmalloc return value before use data
From: Steven Liu <lingjiujianke@gmail.com>
To: starvik@axis.com, jesper.nilsson@axis.com, linux-kernel@vger.kernel.org,
       linux-cris-kernel@axis.com, liuqi@thunderst.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check kmalloc return value before use data

Signed-off-by: Liu Qi <lingjiujianke@gmail.com>
---
 arch/cris/arch-v32/kernel/signal.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/cris/arch-v32/kernel/signal.c
b/arch/cris/arch-v32/kernel/signal.c
index 0b7e3f1..dd69fb4 100644
--- a/arch/cris/arch-v32/kernel/signal.c
+++ b/arch/cris/arch-v32/kernel/signal.c
@@ -656,6 +656,9 @@ int __init
 cris_init_signal(void)
 {
    u16* data = kmalloc(PAGE_SIZE, GFP_KERNEL);
+   if(!data){
+       printk(KERN_ERR "kmalloc memory failed in %s \n", __func__);
+       return -ENOMEM;
+   }

    /* This is movu.w __NR_sigreturn, r9; break 13; */
    data[0] = 0x9c5f;
--
1.7.1
