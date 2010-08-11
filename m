Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932739Ab0HKHlU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 03:41:20 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:64356 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932612Ab0HKHlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 03:41:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=FQ450W+sGklvbTjSn1tjwlaDGvV30UTHxna0Z9bbitySMUaUuklaoXeNB/qLTqKj4I
         qoNddBh6SLX4tHuZwPZgV6cDrlqix3XcQknWrnCU9TeM/moB9HNEYRYu8JEjxYhiWVLY
         7EJFZDtt6975pvjItPwtTw1BJxSWJLi2H088s=
Date: Wed, 11 Aug 2010 09:38:27 +0200
From: Dan Carpenter <error27@gmail.com>
To: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: Jiri Slaby <jslaby@suse.cz>, Srinivas <satyasrinivasp@hcl.in>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch 1/2] mvsas: missing goto statement
Message-ID: <20100811073826.GA30429@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	"James E.J. Bottomley" <James.Bottomley@suse.de>,
	Jiri Slaby <jslaby@suse.cz>, Srinivas <satyasrinivasp@hcl.in>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If mvi_dev is NULL here, then we're supposed return with an error code
but the "goto out" was missing and it could result in a NULL
dereference.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index adedaa9..406246c 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -1648,6 +1648,7 @@ int mvs_abort_task(struct sas_task *task)
 	if (!mvi_dev) {
 		mv_printk("%s:%d TMF_RESP_FUNC_FAILED\n", __func__, __LINE__);
 		rc = TMF_RESP_FUNC_FAILED;
+		goto out;
 	}
 
 	mvi = mvi_dev->mvi_info;
