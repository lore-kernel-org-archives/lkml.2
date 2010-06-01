Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab0FAQ5c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 12:57:32 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:30340 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015Ab0FAQ5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 12:57:31 -0400
Message-ID: <4C053B6B.9000906@oracle.com>
Date: Tue, 01 Jun 2010 09:55:07 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org,
       "arjan@infradead.org" <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v2] Documentation/timers/hpet_example.c: only build on X86
References: <20100528113514.GA3686@osiris.boeblingen.de.ibm.com> <4C0470BE.6040709@oracle.com> <alpine.LFD.2.00.1006010852470.3637@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1006010852470.3637@i5.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090205.4C053BC6.002D:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

We should only build hpet_example on (any) X86, where it is
implemented.  It can cause build errors on other arch-es.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Reported-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Arjan van de Ven <arjan@infradead.org>
---
 Documentation/timers/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-2635-rc1.orig/Documentation/timers/Makefile
+++ lnx-2635-rc1/Documentation/timers/Makefile
@@ -2,7 +2,7 @@
 obj- := dummy.o
 
 # List of programs to build
-hostprogs-y := hpet_example
+hostprogs-$(CONFIG_X86) := hpet_example
 
 # Tell kbuild to always build the programs
 always := $(hostprogs-y)
