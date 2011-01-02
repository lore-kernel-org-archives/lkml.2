Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002Ab1ABXBz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 18:01:55 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41638 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab1ABXBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 18:01:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=i4dW+H6pZFsZNbZtlbeHbQhoXQsY4WHbBGsIOT7GhVL5vxs7aqr34QiJ5K2vzYdf2Q
         NT1e53+ZKAsa45mVa7APnncrVTDrEyzosbAD3uCILf8/7tp/4XVbR7cHfX96ZbNPk/Do
         X1jfZkx7IadP80D6Kh6NKAvF92EiESdIyeYcE=
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        riel@redhat.com, mtosatti@redhat.com, gleb@redhat.com, avi@redhat.com,
        linux-kernel@vger.kernel.org
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH] kvm: Fix section mismatch derived from kvm_guest_cpu_online()
Date: Mon,  3 Jan 2011 00:01:29 +0100
Message-Id: <1294009289-28802-1-git-send-email-sedat.dilek@gmail.com>
X-Mailer: git-send-email 1.7.4.rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From my build.log:

WARNING: arch/x86/built-in.o(.text+0x1bb74): Section mismatch in reference from the function kvm_guest_cpu_online() to the function .cpuinit.text:kvm_guest_cpu_init()
The function kvm_guest_cpu_online() references
the function __cpuinit kvm_guest_cpu_init().
This is often because kvm_guest_cpu_online lacks a __cpuinit
annotation or the annotation of kvm_guest_cpu_init is wrong.

This patch fixes the warning.

Tested with linux-next (next-20101231)

Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
---
 arch/x86/kernel/kvm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 8dc4466..33c07b0 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -493,7 +493,7 @@ static void __init kvm_smp_prepare_boot_cpu(void)
 	native_smp_prepare_boot_cpu();
 }
 
-static void kvm_guest_cpu_online(void *dummy)
+static void __cpuinit kvm_guest_cpu_online(void *dummy)
 {
 	kvm_guest_cpu_init();
 }
-- 
1.7.4.rc0

