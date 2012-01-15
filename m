Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038Ab2AOTEi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 14:04:38 -0500
Received: from lo.gmane.org ([80.91.229.12]:32796 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944Ab2AOTEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 14:04:37 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: walt <w41ter@gmail.com>
Subject: [BISECTED] commit d2a7009f breaks xkbconf
Date: Sun, 15 Jan 2012 11:04:24 -0800
Message-ID: <4F132338.5000104@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
Cc: Eric Paris <eparis@redhat.com>
X-Gmane-NNTP-Posting-Host: adsl-69-234-196-147.dsl.irvnca.pacbell.net
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20120106 Thunderbird/9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric.  The commit below causes a very strange error while running startx.

While X is starting up it runs xkbcomp, which then prints "ERROR: Cannot
open /usr/share/X11/xkb/compiled/server-0.xkm to write keyboard description"
and then X shuts down.  Reverting the commit below fixes the error:

commit d2a7009f0bb03fa22ad08dd25472efa0568126b9
Author: Eric Paris
Date:   Tue Jan 3 12:25:15 2012 -0500

    capabitlies: ns_capable can use the cap helpers rather than lsm call
    
    Just to reduce the number of places to change if we every change the LSM
    hook, use the capability helpers internally when possible.

diff --git a/kernel/capability.c b/kernel/capability.c
index 5f99e5d..4762644 100644
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -384,7 +384,7 @@ bool ns_capable(struct user_namespace *ns, int cap)
                BUG();
        }
 
-       if (security_capable(current_cred(), ns, cap) == 0) {
+       if (has_ns_capability(current, ns, cap)) {
                current->flags |= PF_SUPERPRIV;
                return true;
        }

