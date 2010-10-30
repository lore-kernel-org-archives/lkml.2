Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772Ab0J3I7l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 04:59:41 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47857 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462Ab0J3I7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 04:59:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=QZIIMYY5EA4/hQb+A8ItR/Xaq6alblb66YkC+kzWYHCSMLm+mQRvrcTol+HTuhqLDx
         bqbNIVzL5IlQXSCi8fJ5q1zyU2v2am32B4Ql3acQT85RmhdigOclUdzQ6sMDVD7Hj7mD
         fgyZ1h6HHjObq5GzPqMgK7eGawfXjOifW/CYk=
Message-ID: <4CCBDDC0.8040502@gmail.com>
Date: Sat, 30 Oct 2010 10:56:32 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: x86@kernel.org, andi@firstfloor.org, Tim Bird <tim.bird@am.sony.com>,
        tglx@linutronix.de
Subject: [PATCH] archs: add Kconfig symbol for set memory ro feature
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marco Stornelli <marco.stornelli@gmail.com>

This patch adds a new Kconfig symbol to recognize which arch implements a couple of functions set_memory_ro/set_memory_rw. These functions sets/unsets read-only flag at page table entry level. Until now only x86
has got these functions. Next target will be arm and powerpc.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---

--- linux-2.6.36-orig/arch/Kconfig	2010-09-13 01:07:37.000000000 +0200
+++ linux-2.6.36/arch/Kconfig	2010-10-30 10:27:16.000000000 +0200
@@ -83,6 +83,9 @@ config USER_RETURN_NOTIFIER
 config HAVE_IOREMAP_PROT
 	bool
 
+config HAVE_SET_MEMORY_RO
+	bool
+
 config HAVE_KPROBES
 	bool
 
--- linux-2.6.36-orig/arch/x86/Kconfig	2010-09-13 01:07:37.000000000 +0200
+++ linux-2.6.36/arch/x86/Kconfig	2010-10-30 10:27:38.000000000 +0200
@@ -26,6 +26,7 @@ config X86
 	select HAVE_OPROFILE
 	select HAVE_PERF_EVENTS if (!M386 && !M486)
 	select HAVE_IOREMAP_PROT
+	select HAVE_SET_MEMORY_RO
 	select HAVE_KPROBES
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select ARCH_WANT_FRAME_POINTERS

