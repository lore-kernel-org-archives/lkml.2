Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261Ab0C3XLx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:11:53 -0400
Received: from kroah.org ([198.145.64.141]:48748 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755926Ab0C3XLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:11:48 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:58:11 2010
Message-Id: <20100330225811.050146887@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:57:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jiri Slaby <jirislaby@gmail.com>, James Morris <jmorris@namei.org>,
       Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>,
       David Howells <dhowells@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [05/89] SECURITY: selinux, fix update_rlimit_cpu parameter
In-Reply-To: <20100330230520.GA28779@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jiri Slaby <jirislaby@gmail.com>

commit 17740d89785aeb4143770923d67c293849414710 upstream.

Don't pass current RLIMIT_RTTIME to update_rlimit_cpu() in
selinux_bprm_committing_creds, since update_rlimit_cpu expects
RLIMIT_CPU limit.

Use proper rlim[RLIMIT_CPU].rlim_cur instead to fix that.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: James Morris <jmorris@namei.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Eric Paris <eparis@parisplace.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 security/selinux/hooks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2360,7 +2360,7 @@ static void selinux_bprm_committing_cred
 			initrlim = init_task.signal->rlim + i;
 			rlim->rlim_cur = min(rlim->rlim_max, initrlim->rlim_cur);
 		}
-		update_rlimit_cpu(rlim->rlim_cur);
+		update_rlimit_cpu(current->signal->rlim[RLIMIT_CPU].rlim_cur);
 	}
 }
 


