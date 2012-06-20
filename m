Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932412Ab2FTSXp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 14:23:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53819 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932375Ab2FTSXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 14:23:40 -0400
Message-Id: <20120620173025.573839472@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Date: Wed, 20 Jun 2012 10:31:14 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [ 54/61] remoteproc: fix missing fault indication in error-path
In-Reply-To: <20120620173033.GA5634@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

commit 30338cf09f82523d8747670f7363cc8af347c79f upstream.

If rproc_find_rsc_table() fails, rproc_fw_boot() must set
return-value before jumping to clean_up label. Otherwise no
error value is returned.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/remoteproc/remoteproc_core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -1041,8 +1041,10 @@ static int rproc_fw_boot(struct rproc *r
 
 	/* look for the resource table */
 	table = rproc_find_rsc_table(rproc, fw->data, fw->size, &tablesz);
-	if (!table)
+	if (!table) {
+		ret = -EINVAL;
 		goto clean_up;
+	}
 
 	/* handle fw resources which are required to boot rproc */
 	ret = rproc_handle_boot_rsc(rproc, table, tablesz);


