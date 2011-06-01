Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758200Ab1FAQPK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 12:15:10 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:54632 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755666Ab1FAQPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 12:15:06 -0400
Date: Wed, 1 Jun 2011 09:14:03 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        David Woodhouse <David.Woodhouse@intel.com>,
        akpm <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Simon Kagstrom <simon.kagstrom@netinsight.net>
Subject: [PATCH -next -resend] kmsg_dump.h: needs errno.h
Message-Id: <20110601091403.1e41ef91.randy.dunlap@oracle.com>
In-Reply-To: <20110601134322.f59f5603.sfr@canb.auug.org.au>
References: <20110601134322.f59f5603.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090204.4DE66559.00EF:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix <linux/kmsg_dump.h> when CONFIG_PRINTK is not enabled:

include/linux/kmsg_dump.h:56: error: 'EINVAL' undeclared (first use in this function)
include/linux/kmsg_dump.h:61: error: 'EINVAL' undeclared (first use in this function)

Looks like previous commit:
commit 595dd3d8bf953254d8d2f30f99c54fe09c470040
Author: Randy Dunlap <randy.dunlap@oracle.com>
Date:   Tue Dec 1 10:52:02 2009 -0800

    kmsg_dump: fix build for CONFIG_PRINTK=n

uses EINVAL without having the needed header file(s),
but I'm sure that I build tested that patch also.  oh well.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Simon Kagstrom <simon.kagstrom@netinsight.net>
Cc: David Woodhouse <David.Woodhouse@intel.com>
---
 include/linux/kmsg_dump.h |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20110524.orig/include/linux/kmsg_dump.h
+++ linux-next-20110524/include/linux/kmsg_dump.h
@@ -12,6 +12,7 @@
 #ifndef _LINUX_KMSG_DUMP_H
 #define _LINUX_KMSG_DUMP_H
 
+#include <linux/errno.h>
 #include <linux/list.h>
 
 enum kmsg_dump_reason {
