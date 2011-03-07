Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024Ab1CGLyb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 06:54:31 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:44055 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896Ab1CGLya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 06:54:30 -0500
Date: Mon, 7 Mar 2011 17:24:25 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org, greg@kroah.com, anton@samba.org,
        benh@kernel.crashing.org
Subject: [PATCH 6/7] powerpc/crashdump: Do not fail on NULL pointer
	dereferencing
Message-ID: <20110307115425.GH8194@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    powerpc/crashdump: Do not fail on NULL pointer dereferencing

    Commit: 426b6cb478e60352a463a0d1ec75c1c9fab30b13 upstream

    Signed-off-by: Maxim Uvarov <muvarov@gmail.com>
    Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
    Signed-off-by: Kamalesh babulal <kamalesh@linux.vnet.ibm.com>
    cc: Anton Blanchard <anton@samba.org>
---
 arch/powerpc/kernel/crash.c |    3 +++
 1 file changed, 3 insertions(+)

Index: b/arch/powerpc/kernel/crash.c
===================================================================
--- a/arch/powerpc/kernel/crash.c	2011-03-07 00:59:25.108253005 -0800
+++ b/arch/powerpc/kernel/crash.c	2011-03-07 01:01:07.004296733 -0800
@@ -378,6 +378,9 @@
	for_each_irq(i) {
		struct irq_desc *desc = irq_desc + i;

+		if (!desc || !desc->chip || !desc->chip->eoi)
+			continue;
+
		if (desc->status & IRQ_INPROGRESS)
			desc->chip->eoi(i);

