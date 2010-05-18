Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770Ab0ERHLL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 03:11:11 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37664 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189Ab0ERHLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 03:11:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=vxfv6LRnoHHLZ9SikwiaI6NIvIn8nrIgr9eYjfpHc1SZUtuYp5ECppUa3pftgv0eY2
         HhgSyDjAFElrNEZ2sj968BCQJExKxMtlkgQhkn6e+bqv0Nra2HPx7i7nRu2P2041fH5X
         JU1gFl8wdDbhOKsxOiIHZchdPrfDRHOlXvAS0=
MIME-Version: 1.0
Date: Tue, 18 May 2010 15:11:04 +0800
Message-ID: <AANLkTimy5lY9_-ktN6ZhjCD5mRrFz8P4-2iSJhFesK9k@mail.gmail.com>
Subject: [PATCH] cris: check kmalloc return value before use data
From: Steven Liu <lingjiujianke@gmail.com>
To: starvik@axis.com, "Gerald (Jerry) Carter" <jerry@samba.org>,
       linux-kernel@vger.kernel.org, liuqi@thunderst.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

check kmalloc return value before use data

Signed-off-by: Liu Qi <lingjiujianke@gmail.com>
---
 arch/cris/arch-v32/kernel/signal.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/cris/arch-v32/kernel/signal.c
b/arch/cris/arch-v32/kernel/signal.c
index 0b7e3f1..534eea3 100644
--- a/arch/cris/arch-v32/kernel/signal.c
+++ b/arch/cris/arch-v32/kernel/signal.c
@@ -656,6 +656,10 @@ int __init
 cris_init_signal(void)
 {
        u16* data = kmalloc(PAGE_SIZE, GFP_KERNEL);
+       if(!data){
+               printk(KERN_ERR "kmalloc failed in %s\n", __func__);
+               return -ENOMEM;
+       }

        /* This is movu.w __NR_sigreturn, r9; break 13; */
        data[0] = 0x9c5f;
--
1.7.1
