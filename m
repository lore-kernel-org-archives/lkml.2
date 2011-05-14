Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772Ab1ENR2U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 13:28:20 -0400
Received: from relay01.digicable.hu ([92.249.128.189]:42936 "EHLO
	relay01.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827Ab1ENR2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 13:28:19 -0400
X-Greylist: delayed 1479 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 May 2011 13:28:19 EDT
Message-ID: <4DCEBB85.8040709@freemail.hu>
Date: Sat, 14 May 2011 19:27:33 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Julia Lawall <julia@diku.dk>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86 pci acpi: fix type mismatch
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Original: 178.164.219.74
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

The flags field of struct resource from linux/ioport.h is "unsigned long". Change
the "type" parameter of coalesce_windows() function to match that field. This fixes
the following warning messages when compiling with "make C=1 W=1 bzImage modules":

arch/x86/pci/acpi.c: In function ‘coalesce_windows’:
arch/x86/pci/acpi.c:198: warning: conversion to ‘long unsigned int’ from ‘int’ may change the sign of the result
arch/x86/pci/acpi.c:203: warning: conversion to ‘long unsigned int’ from ‘int’ may change the sign of the result

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
--- linux-2.6.39-rc6/arch/x86/pci/acpi.c.orig	2011-05-04 04:59:13.000000000 +0200
+++ linux-2.6.39-rc6/arch/x86/pci/acpi.c	2011-05-14 19:12:42.000000000 +0200
@@ -188,7 +188,7 @@ static bool resource_contains(struct res
 	return false;
 }

-static void coalesce_windows(struct pci_root_info *info, int type)
+static void coalesce_windows(struct pci_root_info *info, unsigned long type)
 {
 	int i, j;
 	struct resource *res1, *res2;
