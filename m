Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757948Ab1F2VC5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 17:02:57 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:40541 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570Ab1F2VC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 17:02:56 -0400
Subject: [PATCH] gcov: Disable CONSTRUCTORS for UML
From: Vitaliy Ivanov <vitalivanov@gmail.com>
Reply-To: vitalivanov@gmail.com
To: lkml <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>,
        Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vitaliy Ivanov <vitalivanov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Jun 2011 00:02:52 +0300
Message-ID: <1309381372.27360.4.camel@vitaliy-Vostro-1400>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From df71d030a87910e42045dea517bf955caa72d2a8 Mon Sep 17 00:00:00 2001
From: Vitaliy Ivanov <vitalivanov@gmail.com>
Date: Wed, 29 Jun 2011 23:25:32 +0300
Subject: [PATCH] gcov: Disable CONSTRUCTORS for UML

Selecting GCOV for UML causing configuration mismatch:
warning: (GCOV_KERNEL) selects CONSTRUCTORS which has unmet direct dependencies (!UML)

Constructors are not needed for UML.

Signed-off-by: Vitaliy Ivanov <vitalivanov@gmail.com>
---
 kernel/gcov/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/gcov/Kconfig b/kernel/gcov/Kconfig
index 5bf924d..a920281 100644
--- a/kernel/gcov/Kconfig
+++ b/kernel/gcov/Kconfig
@@ -3,7 +3,7 @@ menu "GCOV-based kernel profiling"
 config GCOV_KERNEL
 	bool "Enable gcov-based kernel profiling"
 	depends on DEBUG_FS
-	select CONSTRUCTORS
+	select CONSTRUCTORS if !UML
 	default n
 	---help---
 	This option enables gcov-based code profiling (e.g. for code coverage
-- 
1.7.4.1





