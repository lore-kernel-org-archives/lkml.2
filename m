Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177Ab0KLLOo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 06:14:44 -0500
Received: from exprod5og103.obsmtp.com ([64.18.0.145]:49211 "EHLO
	exprod5og103.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932161Ab0KLLOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 06:14:43 -0500
Subject: [PATCH 06/17] staging/vme/tsi148: remove double freeing of the IRQ in
	.remove
To: Greg KH <greg@kroah.com>
From: Martyn Welch <martyn.welch@ge.com>
Cc: devel@driverdev.osuosl.org,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>,
        "Emilio G. Cota" <cota@braap.org>, LKML <linux-kernel@vger.kernel.org>,
        Bill Pemberton <wfp5p@virginia.edu>
Date: Fri, 12 Nov 2010 11:14:40 +0000
Message-ID: <20101112111440.11631.90734.stgit@ES-BJ21R4J>
In-Reply-To: <20101112111359.11631.84086.stgit@ES-BJ21R4J>
References: <20101112111359.11631.84086.stgit@ES-BJ21R4J>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emilio G. Cota <cota@braap.org>

tsi148_irq_exit is called twice in .remove, which causes an oops.

Remove the second call, which apart from being redundant cannot
possibly work; the CR/CSR space has been already unmapped.

Signed-off-by: Emilio G. Cota <cota@braap.org>
Acked-by: Martyn Welch <martyn.welch@ge.com>
---

 drivers/staging/vme/bridges/vme_tsi148.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)


diff --git a/drivers/staging/vme/bridges/vme_tsi148.c b/drivers/staging/vme/bridges/vme_tsi148.c
index 5c25cd8..2f8f399 100644
--- a/drivers/staging/vme/bridges/vme_tsi148.c
+++ b/drivers/staging/vme/bridges/vme_tsi148.c
@@ -2611,8 +2611,6 @@ static void tsi148_remove(struct pci_dev *pdev)
 		kfree(master_image);
 	}
 
-	tsi148_irq_exit(bridge, pdev);
-
 	iounmap(bridge->base);
 
 	pci_release_regions(pdev);


--
Martyn Welch (Principal Software Engineer)   |   Registered in England and
GE Intelligent Platforms                     |   Wales (3828642) at 100
T +44(0)127322748                            |   Barbirolli Square, Manchester,
E martyn.welch@ge.com                        |   M2 3AB  VAT:GB 927559189
