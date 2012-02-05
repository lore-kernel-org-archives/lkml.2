Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab2BEW1A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:27:00 -0500
Received: from 1wt.eu ([62.212.114.60]:62070 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754449Ab2BEW0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:26:52 -0500
Message-Id: <20120205220950.982277502@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:10:25 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 36/91] powerpc/pseries/hvconsole: Fix dropped console output
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

commit 51d33021425e1f905beb4208823146f2fb6517da upstream.

Return -EAGAIN when we get H_BUSY back from the hypervisor. This
makes the hvc console driver retry, avoiding dropped printks.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/powerpc/platforms/pseries/hvconsole.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Index: longterm-2.6.27/arch/powerpc/platforms/pseries/hvconsole.c
===================================================================
--- longterm-2.6.27.orig/arch/powerpc/platforms/pseries/hvconsole.c	2012-02-05 22:34:33.922915442 +0100
+++ longterm-2.6.27/arch/powerpc/platforms/pseries/hvconsole.c	2012-02-05 22:34:39.962914708 +0100
@@ -73,7 +73,7 @@
 	if (ret == H_SUCCESS)
 		return count;
 	if (ret == H_BUSY)
-		return 0;
+		return -EAGAIN;
 	return -EIO;
 }
 


