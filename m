Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370Ab2BEW0o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:26:44 -0500
Received: from 1wt.eu ([62.212.114.60]:61986 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754107Ab2BEW0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:26:36 -0500
Message-Id: <20120205220949.920575388@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:10:00 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Dan Rosenberg <drosenberg@vsecurity.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 11/91] ARM: 6891/1: prevent heap corruption in OABI semtimedop
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

commit 0f22072ab50cac7983f9660d33974b45184da4f9 upstream.

When CONFIG_OABI_COMPAT is set, the wrapper for semtimedop does not
bound the nsops argument.  A sufficiently large value will cause an
integer overflow in allocation size, followed by copying too much data
into the allocated buffer.  Fix this by restricting nsops to SEMOPM.
Untested.

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/arm/kernel/sys_oabi-compat.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Index: longterm-2.6.27/arch/arm/kernel/sys_oabi-compat.c
===================================================================
--- longterm-2.6.27.orig/arch/arm/kernel/sys_oabi-compat.c	2012-02-05 22:34:34.686915228 +0100
+++ longterm-2.6.27/arch/arm/kernel/sys_oabi-compat.c	2012-02-05 22:34:36.482915240 +0100
@@ -319,7 +319,7 @@
 	long err;
 	int i;
 
-	if (nsops < 1)
+	if (nsops < 1 || nsops > SEMOPM)
 		return -EINVAL;
 	sops = kmalloc(sizeof(*sops) * nsops, GFP_KERNEL);
 	if (!sops)


