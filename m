Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab2IXJuA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 05:50:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:59631 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab2IXJsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 05:48:32 -0400
Date: Mon, 24 Sep 2012 11:48:28 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-kernel@vger.kernel.org
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH/RFC/cosmetic] driver base: use available pointer
Message-ID: <Pine.LNX.4.64.1209241145210.11925@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:Bgd8f790JBpLnESt26dhfLSvcnYVNSMqwp3kQbqtS1m
 C64C9EZxKgamZwZcPm/Wi2j98q30YV9fckU5imI1fPG5WznMVM
 k5NNP3jku2mJV9bogmQsoGRAb7uyiTnETsD6++pAh/EPSWpDj+
 4FuBeeg4oGSRegIPri7BQL4rbFkBSc+35idgsGAMKJE5T55cO4
 XoYvVgO3WlMKVYkuC7H2MUxgGII0FeGEMTlWZ0/ay8PmZNuZPS
 76SYKyDZNKxRNwI+pPG399MKeYq8x28hmn2e+171djGOjL23d1
 0mmq9+0JPNFjFEZK38txTqsOuVrgmuK+weUILW9Xt3T/1Jt1Iq
 48zliqBFUJclkUrpxovM6cPAub2JEzbSOzFcpAKNDEU64f33yX
 njr+tbi5DZuHg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't recalculate an available pointer.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index a1a7225..efe9aa9 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -166,8 +166,8 @@ static void platform_device_release(struct device *dev)
 	struct platform_object *pa = container_of(dev, struct platform_object,
 						  pdev.dev);
 
-	of_device_node_put(&pa->pdev.dev);
-	kfree(pa->pdev.dev.platform_data);
+	of_device_node_put(dev);
+	kfree(dev->platform_data);
 	kfree(pa->pdev.mfd_cell);
 	kfree(pa->pdev.resource);
 	kfree(pa);
