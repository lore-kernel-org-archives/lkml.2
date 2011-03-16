Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316Ab1CPPVU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 11:21:20 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:25525 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab1CPPVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 11:21:13 -0400
Date: Wed, 16 Mar 2011 08:21:05 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Frank Peters <frank.peters@comcast.net>
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        davem@davemloft.net
Subject: [PATCH] net: 2.6.38 Compile Failure e1000e Module
Message-Id: <20110316082105.c911bb1c.randy.dunlap@oracle.com>
In-Reply-To: <20110316103318.19bd03e4.frank.peters@comcast.net>
References: <20110316103318.19bd03e4.frank.peters@comcast.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4D80D564.01A6,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Please test this patch:


From: Randy Dunlap <randy.dunlap@oracle.com>

e1000e needs to select CRC32 for CRC support.
This patch fixes the build error:
ERROR: "crc32_le" [drivers/net/e1000e/e1000e.ko] undefined!

Reported-by: Frank Peters <frank.peters@comcast.net>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/net/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- lnx-2638.orig/drivers/net/Kconfig
+++ lnx-2638/drivers/net/Kconfig
@@ -2099,6 +2099,7 @@ config E1000
 config E1000E
 	tristate "Intel(R) PRO/1000 PCI-Express Gigabit Ethernet support"
 	depends on PCI && (!SPARC32 || BROKEN)
+	select CRC32
 	---help---
 	  This driver supports the PCI-Express Intel(R) PRO/1000 gigabit
 	  ethernet family of adapters. For PCI or PCI-X e1000 adapters,
