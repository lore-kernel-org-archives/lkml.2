Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab1DSPgT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 11:36:19 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:27585 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab1DSPgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 11:36:17 -0400
Date: Tue, 19 Apr 2011 08:35:46 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh <greg@kroah.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] driver core: syscore exports for modular APM
Message-Id: <20110419083546.e8981e49.randy.dunlap@oracle.com>
In-Reply-To: <20110419150641.644638d5.sfr@canb.auug.org.au>
References: <20110419150641.644638d5.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4DADABD5.00F8:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

When CONFIG_APM=m, build fails with:

ERROR: "syscore_suspend" [arch/x86/kernel/apm.ko] undefined!
ERROR: "syscore_resume" [arch/x86/kernel/apm.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/base/syscore.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux-next-20110419.orig/drivers/base/syscore.c
+++ linux-next-20110419/drivers/base/syscore.c
@@ -73,6 +73,7 @@ int syscore_suspend(void)
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(syscore_suspend);
 
 /**
  * syscore_resume - Execute all the registered system core resume callbacks.
@@ -95,6 +96,7 @@ void syscore_resume(void)
 				"Interrupts enabled after %pF\n", ops->resume);
 		}
 }
+EXPORT_SYMBOL_GPL(syscore_resume);
 #endif /* CONFIG_PM_SLEEP */
 
 /**
