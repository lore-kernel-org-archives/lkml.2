Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965689Ab2E0BPy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:15:54 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54259 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965667Ab2E0BPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:15:43 -0400
Message-Id: <20120527002510.971603650@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 09:25:25 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eric Paris <eparis@redhat.com>
Subject: [ 19/91] SELinux: if sel_make_bools errors dont leave inconsistent state
In-Reply-To: <20120527010903.GA18244@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Paris <eparis@redhat.com>

commit 154c50ca4eb9ae472f50b6a481213e21ead4457d upstream.

We reset the bool names and values array to NULL, but do not reset the
number of entries in these arrays to 0.  If we error out and then get back
into this function we will walk these NULL pointers based on the belief
that they are non-zero length.

Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/selinux/selinuxfs.c |    1 +
 1 file changed, 1 insertion(+)

--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -1232,6 +1232,7 @@ static int sel_make_bools(void)
 		kfree(bool_pending_names[i]);
 	kfree(bool_pending_names);
 	kfree(bool_pending_values);
+	bool_num = 0;
 	bool_pending_names = NULL;
 	bool_pending_values = NULL;
 


