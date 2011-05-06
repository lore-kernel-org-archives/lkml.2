Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932745Ab1EFA3v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:29:51 -0400
Received: from kroah.org ([198.145.64.141]:37649 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932741Ab1EFA1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:27:48 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:26:10 2011
Message-Id: <20110506002610.668536422@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:25:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [35/43] ARM: 6891/1: prevent heap corruption in OABI semtimedop
In-Reply-To: <20110506002625.GA20426@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Rosenberg <drosenberg@vsecurity.com>

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
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/kernel/sys_oabi-compat.c
+++ b/arch/arm/kernel/sys_oabi-compat.c
@@ -311,7 +311,7 @@ asmlinkage long sys_oabi_semtimedop(int
 	long err;
 	int i;
 
-	if (nsops < 1)
+	if (nsops < 1 || nsops > SEMOPM)
 		return -EINVAL;
 	sops = kmalloc(sizeof(*sops) * nsops, GFP_KERNEL);
 	if (!sops)


