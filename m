Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501Ab2CIUZn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 15:25:43 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53292 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030461Ab2CITqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:46:31 -0500
Message-Id: <20120309190203.938715861@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:02:22 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "H. Peter Anvin" <hpa@zytor.com>,
        Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@hack.frob.com>
Subject: [ 20/95] regset: Return -EFAULT, not -EIO, on host-side memory fault
In-Reply-To: <20120309194424.GA2134@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "H. Peter Anvin" <hpa@zytor.com>

commit 5189fa19a4b2b4c3bec37c3a019d446148827717 upstream.

There is only one error code to return for a bad user-space buffer
pointer passed to a system call in the same address space as the
system call is executed, and that is EFAULT.  Furthermore, the
low-level access routines, which catch most of the faults, return
EFAULT already.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@hack.frob.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/regset.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/regset.h
+++ b/include/linux/regset.h
@@ -339,7 +339,7 @@ static inline int copy_regset_to_user(st
 		return -EOPNOTSUPP;
 
 	if (!access_ok(VERIFY_WRITE, data, size))
-		return -EIO;
+		return -EFAULT;
 
 	return regset->get(target, regset, offset, size, NULL, data);
 }
@@ -365,7 +365,7 @@ static inline int copy_regset_from_user(
 		return -EOPNOTSUPP;
 
 	if (!access_ok(VERIFY_READ, data, size))
-		return -EIO;
+		return -EFAULT;
 
 	return regset->set(target, regset, offset, size, NULL, data);
 }


