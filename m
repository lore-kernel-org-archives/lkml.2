Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932488Ab1DLOoI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:44:08 -0400
Received: from kroah.org ([198.145.64.141]:57766 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932401Ab1DLOio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:38:44 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 12 07:35:57 2011
Message-Id: <20110412143556.941458179@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 12 Apr 2011 07:35:13 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vasiliy Kulikov <segoon@openwall.com>,
        Mike Christie <michaelc@cs.wisc.edu>,
        James Bottomley <James.Bottomley@suse.de>
Subject: [084/105] [SCSI] scsi_transport_iscsi: make priv_sess file writeable only by root
In-Reply-To: <20110412143613.GA19478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Vasiliy Kulikov <segoon@openwall.com>

commit 523f3c80bc41d663d5b35c0cd6ce0fad7f3e7188 upstream.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Acked-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/scsi_transport_iscsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1847,7 +1847,7 @@ store_priv_session_##field(struct device
 #define iscsi_priv_session_rw_attr(field, format)			\
 	iscsi_priv_session_attr_show(field, format)			\
 	iscsi_priv_session_attr_store(field)				\
-static ISCSI_CLASS_ATTR(priv_sess, field, S_IRUGO | S_IWUGO,		\
+static ISCSI_CLASS_ATTR(priv_sess, field, S_IRUGO | S_IWUSR,		\
 			show_priv_session_##field,			\
 			store_priv_session_##field)
 iscsi_priv_session_rw_attr(recovery_tmo, "%d");


