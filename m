Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086Ab2ACWli (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:41:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40378 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756324Ab2ACWla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:41:30 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:33:23 2012
Message-Id: <20120103223323.266478970@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:33:00 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [27/75] NFSv4.1: Ensure that we handle _all_ SEQUENCE status bits.
In-Reply-To: <20120103223332.GA4112@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 111d489f0fb431f4ae85d96851fbf8d3248c09d8 upstream.

Currently, the code assumes that the SEQUENCE status bits are mutually
exclusive. They are not...

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/nfs4state.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -1525,16 +1525,16 @@ void nfs41_handle_sequence_flag_errors(s
 {
 	if (!flags)
 		return;
-	else if (flags & SEQ4_STATUS_RESTART_RECLAIM_NEEDED)
+	if (flags & SEQ4_STATUS_RESTART_RECLAIM_NEEDED)
 		nfs41_handle_server_reboot(clp);
-	else if (flags & (SEQ4_STATUS_EXPIRED_ALL_STATE_REVOKED |
+	if (flags & (SEQ4_STATUS_EXPIRED_ALL_STATE_REVOKED |
 			    SEQ4_STATUS_EXPIRED_SOME_STATE_REVOKED |
 			    SEQ4_STATUS_ADMIN_STATE_REVOKED |
 			    SEQ4_STATUS_LEASE_MOVED))
 		nfs41_handle_state_revoked(clp);
-	else if (flags & SEQ4_STATUS_RECALLABLE_STATE_REVOKED)
+	if (flags & SEQ4_STATUS_RECALLABLE_STATE_REVOKED)
 		nfs41_handle_recallable_state_revoked(clp);
-	else if (flags & (SEQ4_STATUS_CB_PATH_DOWN |
+	if (flags & (SEQ4_STATUS_CB_PATH_DOWN |
 			    SEQ4_STATUS_BACKCHANNEL_FAULT |
 			    SEQ4_STATUS_CB_PATH_DOWN_SESSION))
 		nfs41_handle_cb_path_down(clp);


