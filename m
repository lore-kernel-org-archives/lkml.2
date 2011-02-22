Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab1BVVga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 16:36:30 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:38450 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950Ab1BVVg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 16:36:28 -0500
Date: Tue, 22 Feb 2011 13:35:29 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andres Salomon <dilinger@queued.net>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] spi/spi_oc_tiny and spi_altera.c: fix build errors
Message-Id: <20110222133529.56b02ebb.randy.dunlap@oracle.com>
In-Reply-To: <20110222132438.02d310e0@queued.net>
References: <20110222132438.02d310e0@queued.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4D642C44.01B8:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Feb 2011 13:24:38 -0800 Andres Salomon wrote:

> Fix the following build error due to a missing semicolon:
> 
>  CC [M]  drivers/spi/spi_oc_tiny.o
> drivers/spi/spi_oc_tiny.c:394: error: expected ‘,’ or ‘;’ before ‘extern’
> make[2]: *** [drivers/spi/spi_oc_tiny.o] Error 1
> 
> Signed-off-by: Andres Salomon <dilinger@queued.net>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Same fix is needed for drivers/spi/spi_altera.c.
I already had this patch ready to send.  Grant, can you extract
the spi_altera.c patch...?


---
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build error due to missing semi-colon:

drivers/spi/spi_altera.c:308: error: expected ',' or ';' before 'extern'
drivers/spi/spi_oc_tiny.c:394: error: expected ',' or ';' before 'extern'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/spi/spi_altera.c  |    2 +-
 drivers/spi/spi_oc_tiny.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20110222.orig/drivers/spi/spi_oc_tiny.c
+++ linux-next-20110222/drivers/spi/spi_oc_tiny.c
@@ -390,7 +390,7 @@ static int __devexit tiny_spi_remove(str
 static const struct of_device_id tiny_spi_match[] = {
 	{ .compatible = "opencores,tiny-spi-rtlsvn2", },
 	{},
-}
+};
 MODULE_DEVICE_TABLE(of, tiny_spi_match);
 #else /* CONFIG_OF */
 #define tiny_spi_match NULL
--- linux-next-20110222.orig/drivers/spi/spi_altera.c
+++ linux-next-20110222/drivers/spi/spi_altera.c
@@ -304,7 +304,7 @@ static int __devexit altera_spi_remove(s
 static const struct of_device_id altera_spi_match[] = {
 	{ .compatible = "ALTR,spi-1.0", },
 	{},
-}
+};
 MODULE_DEVICE_TABLE(of, altera_spi_match);
 #else /* CONFIG_OF */
 #define altera_spi_match NULL

