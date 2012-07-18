Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296Ab2GRADa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 20:03:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49131 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177Ab2GRADW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 20:03:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dave Jones <davej@redhat.com>
Subject: [ 01/37] Remove easily user-triggerable BUG from generic_setlease
Date: Tue, 17 Jul 2012 17:02:38 -0700
Message-Id: <20120717232431.399005532@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120717232455.GA5994@kroah.com>
References: <20120717232455.GA5994@kroah.com>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jones <davej@redhat.com>

commit 8d657eb3b43861064d36241e88d9d61c709f33f0 upstream.

This can be trivially triggered from userspace by passing in something unexpected.

    kernel BUG at fs/locks.c:1468!
    invalid opcode: 0000 [#1] SMP
    RIP: 0010:generic_setlease+0xc2/0x100
    Call Trace:
      __vfs_setlease+0x35/0x40
      fcntl_setlease+0x76/0x150
      sys_fcntl+0x1c6/0x810
      system_call_fastpath+0x1a/0x1f

Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/locks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1465,7 +1465,7 @@ int generic_setlease(struct file *filp,
 	case F_WRLCK:
 		return generic_add_lease(filp, arg, flp);
 	default:
-		BUG();
+		return -EINVAL;
 	}
 }
 EXPORT_SYMBOL(generic_setlease);


