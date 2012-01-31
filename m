Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321Ab2AaQ4p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 11:56:45 -0500
Received: from smtp2.ustc.edu.cn ([202.38.64.46]:38876 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752400Ab2AaQ4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 11:56:43 -0500
X-Greylist: delayed 491 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Jan 2012 11:56:43 EST
Date: Wed, 1 Feb 2012 00:48:28 +0800 (CST)
From: hchunhui@mail.ustc.edu.cn
To: hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Message-ID: <32892299.2931391328028508117.JavaMail.coremail@mailweb>
Subject: [PATCH] i386 boot: fix inl() function
MIME-Version: 1.0
Content-Type: text/plain; charset=GBK
Content-Transfer-Encoding: 7bit
X-Originating-IP: [123.79.21.232]
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT_U3b build
 111111(15684.4153.3993) Copyright (c) 2002-2012 www.mailtech.cn ustccn
X-CM-TRANSID: yia_0ZD7FwFcGyhPgI1bAA--.64333W
X-CM-SenderInfo: pkfk30xkxlqzxdloh3xvwfhvlgxou0/1tbiAQIKEUqSNbuGYAABsp
X-Coremail-Antispam: 1U50xBIdaVrnn0S07vEb7Iv0xC_Ar1lV2xY67kC6x804xJvcS
	sGvfC2KfnxnUU==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


"u32 port" in inl() should be "u16 port".

Signed-off-by: He Chunhui <hchunhui@mail.ustc.edu.cn>
--- linux-3.3-rc1/arch/x86/boot/boot.h.orig	2012-01-31 23:49:15.858738690 +0800
+++ linux-3.3-rc1/arch/x86/boot/boot.h	2012-01-31 23:49:46.002072974 +0800
@@ -67,7 +67,7 @@ static inline void outl(u32 v, u16 port)
 {
 	asm volatile("outl %0,%1" : : "a" (v), "dN" (port));
 }
-static inline u32 inl(u32 port)
+static inline u32 inl(u16 port)
 {
 	u32 v;
 	asm volatile("inl %1,%0" : "=a" (v) : "dN" (port));
