Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960Ab1BPBkc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:40:32 -0500
Received: from kroah.org ([198.145.64.141]:39010 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757031Ab1BPAUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:20:05 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:32 2011
Message-Id: <20110216001432.833880972@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:12:14 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kashyap Desai <kashyap.desai@lsi.com>,
        James Bottomley <James.Bottomley@suse.de>
Subject: [077/272] [SCSI] mpt2sas: add missing initialization of scsih_cmds
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Kashyap, Desai <kashyap.desai@lsi.com>

commit d685c262083dcd5fd98b7499b22a377a3225229c upstream.

Internal command scsih_cmds init is included in mpt2sas_base_attach.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/mpt2sas/mpt2sas_base.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -3662,6 +3662,11 @@ mpt2sas_base_attach(struct MPT2SAS_ADAPT
 	ioc->scsih_cmds.status = MPT2_CMD_NOT_USED;
 	mutex_init(&ioc->scsih_cmds.mutex);
 
+	/* scsih internal command bits */
+	ioc->scsih_cmds.reply = kzalloc(ioc->reply_sz, GFP_KERNEL);
+	ioc->scsih_cmds.status = MPT2_CMD_NOT_USED;
+	mutex_init(&ioc->scsih_cmds.mutex);
+
 	/* task management internal command bits */
 	ioc->tm_cmds.reply = kzalloc(ioc->reply_sz, GFP_KERNEL);
 	ioc->tm_cmds.status = MPT2_CMD_NOT_USED;


