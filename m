Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551Ab0HMVET (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 17:04:19 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55927 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387Ab0HMVEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 17:04:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :user-agent;
        b=aDUcls7Xk6l4Qdr7VqCu2WotaUGIX4jo+IKyNu3HpvpStK2EITCFChGs68m5ZMMq3u
         ve4thbphT0eFWP9AgVMSDeI6WYxEyOU15cStkKDBwoft1JboHakxIE9ynllbuVtLyTjx
         DA5HezJRRQo/mS4nWi59z9ZPiHt1bkluVLdEo=
Date: Fri, 13 Aug 2010 23:03:50 +0200
From: Dan Carpenter <error27@gmail.com>
To: Ravi Anand <ravi.anand@qlogic.com>
Cc: Vikas Chaudhary <vikas.chaudhary@qlogic.com>, iscsi-driver@qlogic.com,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        Karen Higgins <karen.higgins@qlogic.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] qla4xxx: initialize some variables for gcc
Message-ID: <20100813210350.GT645@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Ravi Anand <ravi.anand@qlogic.com>,
	Vikas Chaudhary <vikas.chaudhary@qlogic.com>,
	iscsi-driver@qlogic.com,
	"James E.J. Bottomley" <James.Bottomley@suse.de>,
	Karen Higgins <karen.higgins@qlogic.com>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gcc complains because these variables aren't initialized.

drivers/scsi/qla4xxx/ql4_nx.c: In function ‘qla4_8xxx_get_flash_info’:
drivers/scsi/qla4xxx/ql4_nx.c:1952: warning: ‘fid’ may be used uninitialized in this function
drivers/scsi/qla4xxx/ql4_nx.c:1952: note: ‘fid’ was declared here
drivers/scsi/qla4xxx/ql4_nx.c:1952: warning: ‘mid’ may be used uninitialized in this function
drivers/scsi/qla4xxx/ql4_nx.c:1952: note: ‘mid’ was declared here

It's not a big deal.  We only print the uninitialized value on error
paths when debugging is enabled.  Still it's nice to clean it up and to
stop gcc from grumbling.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index 3e119ae..e443fa6 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -1949,7 +1949,8 @@ qla4_8xxx_get_fdt_info(struct scsi_qla_host *ha)
 	uint16_t cnt, chksum;
 	uint16_t *wptr;
 	struct qla_fdt_layout *fdt;
-	uint16_t mid, fid;
+	uint16_t mid = -1;
+	uint16_t fid = -1;
 	struct ql82xx_hw_data *hw = &ha->hw;
 
 	hw->flash_conf_off = FARX_ACCESS_FLASH_CONF;
