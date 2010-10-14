Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931Ab0JNSbs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 14:31:48 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:20421 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722Ab0JNSbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 14:31:47 -0400
Message-ID: <4CB74C5F.4000905@oracle.com>
Date: Thu, 14 Oct 2010 11:30:55 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
CC: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
        Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org
Subject: [PATCH -next v2] mmc: fix cb710 kconfig dependency warning
References: <20101013181519.6ff00e10.randy.dunlap@oracle.com> <20101014090442.GA14454@rere.qmqm.pl>
In-Reply-To: <20101014090442.GA14454@rere.qmqm.pl>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kconfig dependency warning to satisfy dependencies:

warning: (MMC_CB710 && MMC && PCI) selects CB710_CORE which has unmet direct dependencies (MISC_DEVICES && PCI)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: <mirq-linux@rere.qmqm.pl>
---
 drivers/mmc/host/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20101013.orig/drivers/mmc/host/Kconfig
+++ linux-next-20101013/drivers/mmc/host/Kconfig
@@ -395,6 +395,7 @@ config MMC_TMIO
 config MMC_CB710
 	tristate "ENE CB710 MMC/SD Interface support"
 	depends on PCI
+	select MISC_DEVICES
 	select CB710_CORE
 	help
 	  This option enables support for MMC/SD part of ENE CB710/720 Flash
