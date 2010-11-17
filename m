Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935468Ab0KQULF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 15:11:05 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:42218 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935286Ab0KQULD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 15:11:03 -0500
Message-ID: <4CE436C0.5050802@kernel.org>
Date: Wed, 17 Nov 2010 12:10:40 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101026 SUSE/3.0.10 Thunderbird/3.0.10
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] pci: Skip id checking if no id is passed
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Will get warning when pci stub driver is built-in kenel like:
pci-stub: invalid id string ""

So stop early if no id is passed.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/pci-stub.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6/drivers/pci/pci-stub.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci-stub.c
+++ linux-2.6/drivers/pci/pci-stub.c
@@ -47,6 +47,10 @@ static int __init pci_stub_init(void)
 	if (rc)
 		return rc;
 
+	/* no ids passed actually */
+	if (ids[0] == '\0')
+		return 0;
+
 	/* add ids specified in the module parameter */
 	p = ids;
 	while ((id = strsep(&p, ","))) {
