Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012Ab0KJN66 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 08:58:58 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41982 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755816Ab0KJN6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 08:58:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=b/MsdUXpV4WuKfhX921Elj2v6h0daAwwgKLfXM45sUETyF4HJvLTPwNXYdlWoDt3z4
         +JuY72r+2Y2GStrvIry/0/lCKdSfMwiTeGdfPaacuUT1xAjtbeOxKX6p56jLVjykygfY
         YnHHf0a2ljmdgk95Kwr8v0LWQbkCUQJ/w7uyE=
MIME-Version: 1.0
Date: Wed, 10 Nov 2010 21:58:52 +0800
Message-ID: <AANLkTi=butKgG8VktAu0V12aBKTetOJwiGkcTLG_RZWB@mail.gmail.com>
Subject: [PATCH] fix the poll method of bsg file operations in Block layer
 SCSI generic driver
From: Hillf Danton <dhillf@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, "Zou, Yi" <yi.zou@intel.com>,
        Joe Eykholt <jeykholt@cisco.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Though it looks like a typo, the check for POLLOUT is computed incorrectly.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/block/bsg.c	2010-09-13 07:07:38.000000000 +0800
+++ b/block/bsg.c	2010-11-10 21:40:30.000000000 +0800
@@ -874,6 +874,8 @@ static unsigned int bsg_poll(struct file
 	if (!list_empty(&bd->done_list))
 		mask |= POLLIN | POLLRDNORM;
 	if (bd->queued_cmds >= bd->max_queue)
+		;
+	else
 		mask |= POLLOUT;
 	spin_unlock_irq(&bd->lock);
