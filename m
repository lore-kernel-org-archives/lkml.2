Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717Ab2LNA56 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 19:57:58 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25310 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753753Ab2LNA54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 19:57:56 -0500
X-Authority-Analysis: v=2.0 cv=O9a7TWBW c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=tNlbskdacWIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=fhAgPGMYB1wA:10 a=rOUgymgbAAAA:8 a=WomNyAZRArXkpGMvjdoA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1355446675.17101.388.camel@gandalf.local.home>
Subject: [PATCH] staging: Make SystemBase PCI Multiport UART only for x86
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>
Date: Thu, 13 Dec 2012 19:57:55 -0500
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sb105x SystemBase PCI UART driver in staging has code specific for
x86. This breaks allyesconfig builds for other archs. For now, the quick
fix is simply to make this driver depend on x86.

When I get time, I'll swap this card out of my main machine and put it
into my PowerPC64 box, and get it working there. Then it may become a
good samaritan and play nice with other archs.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/drivers/staging/sb105x/Kconfig b/drivers/staging/sb105x/Kconfig
index ac87c5e..1facad6 100644
--- a/drivers/staging/sb105x/Kconfig
+++ b/drivers/staging/sb105x/Kconfig
@@ -2,6 +2,7 @@ config SB105X
 	tristate "SystemBase PCI Multiport UART"
 	select SERIAL_CORE
 	depends on PCI
+	depends on X86
 	help
 	  A driver for the SystemBase Multi-2/PCI serial card
 


