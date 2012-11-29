Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab2K2Xn0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 18:43:26 -0500
Received: from casper.infradead.org ([85.118.1.10]:39974 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303Ab2K2XnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 18:43:25 -0500
Message-ID: <50B7F30C.1060105@infradead.org>
Date: Thu, 29 Nov 2012 15:43:08 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Ville Syrjala <syrjala@sci.fi>
Subject: [PATCH -next] of: export "allnodes" to fixx w1-gpio.c modular build
References: <20121129174057.99da02b15426c76054d05592@canb.auug.org.au>
In-Reply-To: <20121129174057.99da02b15426c76054d05592@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix build when CONFIG_W1_MASTER_GPIO=m by exporting "allnodes".

ERROR: "allnodes" [drivers/w1/masters/w1-gpio.ko] undefined!

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Ville Syrjala <syrjala@sci.fi>
---
 drivers/of/base.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20121129.orig/drivers/of/base.c
+++ linux-next-20121129/drivers/of/base.c
@@ -46,6 +46,7 @@ struct alias_prop {
 static LIST_HEAD(aliases_lookup);
 
 struct device_node *allnodes;
+EXPORT_SYMBOL(allnodes);
 struct device_node *of_chosen;
 struct device_node *of_aliases;
 
