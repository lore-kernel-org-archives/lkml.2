Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760655Ab2BJWnt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:43:49 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42369 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932697Ab2BJWnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:43:45 -0500
MIME-Version: 1.0
Message-Id: <20120210222951.059481219@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:30:27 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Marco Sanvido <marco@purestorage.com>,
        Roland Dreier <roland@purestorage.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [patch 68/86] target: Allow PERSISTENT RESERVE IN for non-reservation holder
In-Reply-To: <20120210223514.GA24190@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marco Sanvido <marco@purestorage.com>

commit 6816966a8418b980481b4dced7eddd1796b145e8 upstream.

Initiators that aren't the active reservation holder should be able to
do a PERSISTENT RESERVE IN command in all cases, so add it to the list
of allowed CDBs in core_scsi3_pr_seq_non_holder().

Signed-off-by: Marco Sanvido <marco@purestorage.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_pr.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -481,6 +481,7 @@ static int core_scsi3_pr_seq_non_holder(
 	case READ_MEDIA_SERIAL_NUMBER:
 	case REPORT_LUNS:
 	case REQUEST_SENSE:
+	case PERSISTENT_RESERVE_IN:
 		ret = 0; /*/ Allowed CDBs */
 		break;
 	default:


