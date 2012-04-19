Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965141Ab2DSVRO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:17:14 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:38471 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965121Ab2DSVRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:17:09 -0400
Message-Id: <20120419210822.409685910@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:09:02 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eric Paris <eparis@redhat.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        James Morris <james.l.morris@oracle.com>
Subject: [ 44/68] fcaps: clear the same personality flags as suid when fcaps are used
In-Reply-To: <20120419210923.GA18589@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Paris <eparis@redhat.com>

commit d52fc5dde171f030170a6cb78034d166b13c9445 upstream.

If a process increases permissions using fcaps all of the dangerous
personality flags which are cleared for suid apps should also be cleared.
Thus programs given priviledge with fcaps will continue to have address space
randomization enabled even if the parent tried to disable it to make it
easier to attack.

Signed-off-by: Eric Paris <eparis@redhat.com>
Reviewed-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: James Morris <james.l.morris@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/commoncap.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -514,6 +514,11 @@ int cap_bprm_set_creds(struct linux_binp
 	}
 skip:
 
+	/* if we have fs caps, clear dangerous personality flags */
+	if (!cap_issubset(new->cap_permitted, old->cap_permitted))
+		bprm->per_clear |= PER_CLEAR_ON_SETID;
+
+
 	/* Don't let someone trace a set[ug]id/setpcap binary with the revised
 	 * credentials unless they have the appropriate permit
 	 */


