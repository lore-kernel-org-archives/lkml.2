Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab0EFXpG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 19:45:06 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:29194 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab0EFXpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 19:45:02 -0400
Date: Thu, 6 May 2010 16:43:03 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       devel@driverdev.osuosl.org
Subject: [PATCH -next] staging: fix arlan build-braces
Message-Id: <20100506164303.510040dd.randy.dunlap@oracle.com>
In-Reply-To: <20100506151502.f97afe54.sfr@canb.auug.org.au>
References: <20100506151502.f97afe54.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090208.4BE35476.0090:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

The braces on the writeControlRegister() macro are not sufficient
(at least for one version of gcc):

drivers/staging/arlan/arlan-main.c:230: error: 'else' without a previous 'if'
drivers/staging/arlan/arlan-main.c:236: error: 'else' without a previous 'if'
drivers/staging/arlan/arlan-main.c:242: error: 'else' without a previous 'if'
drivers/staging/arlan/arlan-main.c:250: error: 'else' without a previous 'if'
drivers/staging/arlan/arlan-main.c:298: error: 'else' without a previous 'if'
drivers/staging/arlan/arlan-main.c:324: error: 'else' without a previous 'if'
drivers/staging/arlan/arlan-main.c:348: error: 'else' without a previous 'if'
drivers/staging/arlan/arlan-main.c:362: error: 'else' without a previous 'if'
drivers/staging/arlan/arlan-main.c:367: error: 'else' without a previous 'if'
drivers/staging/arlan/arlan-main.c:372: error: 'else' without a previous 'if'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/staging/arlan/arlan.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- linux-next-20100506.orig/drivers/staging/arlan/arlan.h
+++ linux-next-20100506/drivers/staging/arlan/arlan.h
@@ -461,10 +461,11 @@ struct arlan_private {
    int cr;   \
    \
    cr = readControlRegister(dev);\
-   if (cr & ARLAN_CHANNEL_ATTENTION) \
+   if (cr & ARLAN_CHANNEL_ATTENTION) { \
       writeControlRegister(dev, (cr & ~ARLAN_CHANNEL_ATTENTION));\
-   else \
+   } else { \
       writeControlRegister(dev, (cr | ARLAN_CHANNEL_ATTENTION));\
+   } \
 }
 
 #define clearChannelAttention(dev) { \
