Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904Ab0FJNWF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 09:22:05 -0400
Received: from mail.gmx.net ([213.165.64.20]:37405 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750937Ab0FJNWC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 09:22:02 -0400
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX18vJ7A5gtgvHxxF13yDhWgU6/JmDIGebUrFwXu90s
	pr6VofywdoClaK
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: devel@driverdev.osuosl.org
Subject: Re: [PATCH] rt3070: Fixed a line over 80 character warning reported by checkpatch.pl tool
Date: Thu, 10 Jun 2010 15:21:42 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.34-0.slh.7-sidux-686; KDE/4.4.4; i686; ; )
Cc: Matti Lammi <mattij.lammi@gmail.com>, gregkh@suse.de,
       andrea.gelmini@gelma.net, bzolnier@gmail.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <1276164045-6003-1-git-send-email-mattij.lammi@gmail.com>
In-Reply-To: <1276164045-6003-1-git-send-email-mattij.lammi@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006101521.45409.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thursday 10 June 2010, Matti Lammi wrote:
> Divided a comment line into two separet lines in drivers/staging/rt3070/md4.h.

Isn't drivers/staging/rt3070/ as a whole dead code by now? What about the 
following removal patch instead (compile tested and no complaints from 
rt30[79]0 users yet)?


As a side note, rt2800pci/ rt2800usb from drivers/net/wireless/rt2x00/ have
become fully functional for rt2770, rt2860, rt2870 (and I've gotten 
very positive feedback for rt3070/ rt3090) with 2.6.35, so the staging 
rt2860/ rt2870 drivers could be removed soon (now?). rt35xx support is 
rt2x00-only anyways and HT rates aren't actually achievable by staging 
(only by newer out-of-tree vendor drivers) or rt2x00 (work is under way) 
yet.


From: Stefan Lippers-Hollmann <s.l-h@gmx.de>
Date: Wed, 24 Mar 2010 20:56:13 +0000
Subject: [PATCH] rt3070: remove dead code

While merging rt30[79]0 support into rt28[67]0, drivers/staging/rt3070/md4.h 
has been forgotten, while it isn't referenced from the remaining drivers 
anymore; remove it.

Signed-off-by: Stefan Lippers-Hollmann <s.l-h@gmx.de>
---
 drivers/staging/rt3070/md4.h |   42 ------------------------------------------
 1 files changed, 0 insertions(+), 42 deletions(-)
 delete mode 100644 drivers/staging/rt3070/md4.h

diff --git a/drivers/staging/rt3070/md4.h b/drivers/staging/rt3070/md4.h
deleted file mode 100644
index b3fb637..0000000
--- a/drivers/staging/rt3070/md4.h
+++ /dev/null
@@ -1,42 +0,0 @@
-/*
- *************************************************************************
- * Ralink Tech Inc.
- * 5F., No.36, Taiyuan St., Jhubei City,
- * Hsinchu County 302,
- * Taiwan, R.O.C.
- *
- * (c) Copyright 2002-2007, Ralink Technology, Inc.
- *
- * This program is free software; you can redistribute it and/or modify  *
- * it under the terms of the GNU General Public License as published by  *
- * the Free Software Foundation; either version 2 of the License, or     *
- * (at your option) any later version.                                   *
- *                                                                       *
- * This program is distributed in the hope that it will be useful,       *
- * but WITHOUT ANY WARRANTY; without even the implied warranty of        *
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
- * GNU General Public License for more details.                          *
- *                                                                       *
- * You should have received a copy of the GNU General Public License     *
- * along with this program; if not, write to the                         *
- * Free Software Foundation, Inc.,                                       *
- * 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             *
- *                                                                       *
- *************************************************************************
- */
-
-#ifndef __MD4_H__
-#define __MD4_H__
-
-/* MD4 context. */
-typedef	struct	_MD4_CTX_	{
-	unsigned long	state[4];        /* state (ABCD) */
-	unsigned long	count[2];        /* number of bits, modulo 2^64 (lsb first) */
-	u8	buffer[64];      /* input buffer */
-}	MD4_CTX;
-
-void MD4Init(MD4_CTX *);
-void MD4Update(MD4_CTX *, u8 *, UINT);
-void MD4Final(u8 [16], MD4_CTX *);
-
-#endif /*__MD4_H__*/
-- 
1.7.1

