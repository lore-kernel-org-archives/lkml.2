Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab1DSUFE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:05:04 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:27914 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960Ab1DSUFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:05:01 -0400
Date: Tue, 19 Apr 2011 13:04:19 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Simon Danner <danner.simon@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        user-mode-linux-devel@lists.sourceforge.net,
        Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] uml: fix hppfs build
Message-Id: <20110419130419.5f1f8539.randy.dunlap@oracle.com>
In-Reply-To: <BANLkTin1=uPcyBgy9S_2TJASk8qTkeueEA@mail.gmail.com>
References: <BANLkTin1=uPcyBgy9S_2TJASk8qTkeueEA@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4DADEACA.0005:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Make HoneyPot ProcFS depend on CONFIG_PROC_FS so that it will build.
Recommended by Christoph Hellwig.

Fixes kernel bugzilla #33692:
  https://bugzilla.kernel.org/show_bug.cgi?id=33692

Reported-by: Simon Danner <danner.simon@gmail.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc:	Jeff Dike <jdike@addtoit.com>
Cc:	Richard Weinberger <richard@nod.at>
Cc:	user-mode-linux-devel@lists.sourceforge.net
Cc:	Christoph Hellwig <hch@infradead.org>
---
 arch/um/Kconfig.um |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-2639-rc4.orig/arch/um/Kconfig.um
+++ lnx-2639-rc4/arch/um/Kconfig.um
@@ -47,7 +47,7 @@ config HOSTFS
 
 config HPPFS
 	tristate "HoneyPot ProcFS (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	depends on EXPERIMENTAL && PROC_FS
 	help
 	  hppfs (HoneyPot ProcFS) is a filesystem which allows UML /proc
 	  entries to be overridden, removed, or fabricated from the host.
