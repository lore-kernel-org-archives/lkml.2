Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757148Ab0FAQO1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 12:14:27 -0400
Received: from mail.vyatta.com ([76.74.103.46]:35923 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932122Ab0FAQOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 12:14:17 -0400
Date: Tue, 1 Jun 2010 09:11:44 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] squashfs: xattr_handler don't inline
Message-ID: <20100601091144.1ff3e677@nehalam>
In-Reply-To: <AANLkTilWjRvjl5M_4lenw3aMI57eDYjOV96k3KmxrNwB@mail.gmail.com>
References: <4BFC7269.3070309@lougher.demon.co.uk>
	<AANLkTilWjRvjl5M_4lenw3aMI57eDYjOV96k3KmxrNwB@mail.gmail.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't need to explicitly inline this function, it causes a sparse
warning; and GCC will inline it already.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

---
Patch against 2.6.35-rc1

--- a/fs/squashfs/xattr.c	2010-06-01 08:38:44.659739327 -0700
+++ b/fs/squashfs/xattr.c	2010-06-01 08:39:29.731326492 -0700
@@ -295,7 +295,7 @@ static const struct xattr_handler squash
 	.get	= squashfs_security_get
 };
 
-static inline const struct xattr_handler *squashfs_xattr_handler(int type)
+static const struct xattr_handler *squashfs_xattr_handler(int type)
 {
 	if (type & ~(SQUASHFS_XATTR_PREFIX_MASK | SQUASHFS_XATTR_VALUE_OOL))
 		/* ignore unrecognised type */
