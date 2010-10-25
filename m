Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571Ab0JYQHl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 12:07:41 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52895 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267Ab0JYQHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 12:07:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Xm7qYMsfTBKJHOlDUHcfdshE2pIdgtqxjkpXcup8OaDWmG4PoW80b2+4OZDboXnzPm
         f3OMW+t0pj7gBQYhByK9ECHOjuB0XH4/WEEzJ5fMRGY63cq15skY52aImzqIqluAMHG5
         A1ja4/uzn+dBr3eBvDGtKsE8UnWoUuP6ckajA=
Subject: Re: [PATCH 3/3] sparc32: fix build failure on CONFIG_SPARC_LEON
From: Namhyung Kim <namhyung@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101025.090043.71110898.davem@davemloft.net>
References: <1288021958-3130-1-git-send-email-namhyung@gmail.com>
	 <1288021958-3130-3-git-send-email-namhyung@gmail.com>
	 <20101025.090043.71110898.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Oct 2010 01:07:29 +0900
Message-ID: <1288022849.1689.14.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010-10-25 (월), 09:00 -0700, David Miller:
> From: Namhyung Kim <namhyung@gmail.com>
> Date: Tue, 26 Oct 2010 00:52:38 +0900
> 
> >   CC      arch/sparc/kernel/irq_32.o
> > arch/sparc/kernel/irq_32.c: In function 'request_fast_irq':
> > arch/sparc/kernel/irq_32.c:370:25: error: conflicting types for 'trapbase_cpu1'
> 
> I doubt SMP LEON chips even exist, so better to just anti-dep
> this in arch/sparc/Kconfig

If I understood correctly, you meant this?


diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 4db8bc0..a6685ba 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -463,7 +463,7 @@ config SERIAL_CONSOLE
 
 config SPARC_LEON
        bool "Sparc Leon processor family"
-       depends on SPARC32
+       depends on SPARC32 && !SMP
        ---help---
          If you say Y here if you are running on a SPARC-LEON
processor.
          The LEON processor is a synthesizable VHDL model of the


-- 
Regards,
Namhyung Kim


