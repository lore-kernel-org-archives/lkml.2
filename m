Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab0CVMMy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 08:12:54 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:39156 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784Ab0CVMMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 08:12:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=hy7+riqbTNZ3Bg3VEEQqpZ65RVWsxm02F+1c9o2z7cTFXhxcv5y1ZV2Rqa1q3HjQiu
         gSt/8nZ3c/bi0FiRR4GQiQtbbIoUUKtYfOxsRF7NCw8qXjhrS/+peiBAjonUz3gG4JBb
         oWiqoe0X/nZGn9eVBYpZphj2dZI3ONN+mBmXo=
Date: Mon, 22 Mar 2010 15:12:42 +0300
From: Dan Carpenter <error27@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
       Richard =?iso-8859-1?Q?R=F6jfors?= 
	<richard.rojfors@pelagicore.com>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] mfd: off by one calculating size
Message-ID: <20100322121242.GL21571@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Richard =?iso-8859-1?Q?R=F6jfors?= <richard.rojfors@pelagicore.com>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm pretty sure that it should be + 1 here.  It's an off by one, because
we start counting at zero.

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
Found by a static checker and untested.  Please review carefully.

diff --git a/drivers/mfd/timberdale.h b/drivers/mfd/timberdale.h
index 8d27ffa..902c451 100644
--- a/drivers/mfd/timberdale.h
+++ b/drivers/mfd/timberdale.h
@@ -66,7 +66,7 @@
 
 #define CHIPCTLOFFSET	0x800
 #define CHIPCTLEND	0x8ff
-#define CHIPCTLSIZE	(CHIPCTLEND - CHIPCTLOFFSET)
+#define CHIPCTLSIZE	(CHIPCTLEND - CHIPCTLOFFSET + 1)
 
 #define INTCOFFSET	0xc00
 #define INTCEND		0xfff
