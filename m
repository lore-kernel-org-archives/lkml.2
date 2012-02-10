Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760379Ab2BJW44 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:56:56 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42369 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933058Ab2BJWpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:45:08 -0500
MIME-Version: 1.0
Message-Id: <20120210223443.959612337@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:33:46 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Marco Sanvido <marco@purestorage.com>,
        Roland Dreier <roland@purestorage.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [patch 42/55] target: Use correct preempted registration sense code
In-Reply-To: <20120210223500.GA24178@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marco Sanvido <marco@purestorage.com>

commit 9e08e34e3735ae057eb3834da3570995811b7eb9 upstream.

The comments quote the right parts of the spec:

   * d) Establish a unit attention condition for the
   *    initiator port associated with every I_T nexus
   *    that lost its registration other than the I_T
   *    nexus on which the PERSISTENT RESERVE OUT command
   *    was received, with the additional sense code set
   *    to REGISTRATIONS PREEMPTED.

and

   * e) Establish a unit attention condition for the initiator
   *    port associated with every I_T nexus that lost its
   *    persistent reservation and/or registration, with the
   *    additional sense code set to REGISTRATIONS PREEMPTED;

but the actual code accidentally uses ASCQ_2AH_RESERVATIONS_PREEMPTED
instead of ASCQ_2AH_REGISTRATIONS_PREEMPTED.  Fix this.

Signed-off-by: Marco Sanvido <marco@purestorage.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_pr.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -3079,7 +3079,7 @@ static int core_scsi3_pro_preempt(
 			if (!(calling_it_nexus))
 				core_scsi3_ua_allocate(pr_reg_nacl,
 					pr_res_mapped_lun, 0x2A,
-					ASCQ_2AH_RESERVATIONS_PREEMPTED);
+					ASCQ_2AH_REGISTRATIONS_PREEMPTED);
 		}
 		spin_unlock(&pr_tmpl->registration_lock);
 		/*
@@ -3191,7 +3191,7 @@ static int core_scsi3_pro_preempt(
 		 *    additional sense code set to REGISTRATIONS PREEMPTED;
 		 */
 		core_scsi3_ua_allocate(pr_reg_nacl, pr_res_mapped_lun, 0x2A,
-				ASCQ_2AH_RESERVATIONS_PREEMPTED);
+				ASCQ_2AH_REGISTRATIONS_PREEMPTED);
 	}
 	spin_unlock(&pr_tmpl->registration_lock);
 	/*


