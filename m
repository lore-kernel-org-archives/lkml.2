Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932688Ab0IXQ23 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:28:29 -0400
Received: from kroah.org ([198.145.64.141]:38342 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932663Ab0IXQ2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:28:24 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:26:18 2010
Message-Id: <20100924162618.020512493@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:24:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jan Kara <jack@suse.cz>, Jens Axboe <jaxboe@fusionio.com>
Subject: [36/80] bdi: Initialize noop_backing_dev_info properly
In-Reply-To: <20100924162706.GA7381@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jan Kara <jack@suse.cz>

commit 976e48f8a5b02fc33f3e5cad87fb3fcea041a49c upstream.

Properly initialize this backing dev info so that writeback code does not
barf when getting to it e.g. via sb->s_bdi.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/backing-dev.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -29,6 +29,7 @@ EXPORT_SYMBOL_GPL(default_backing_dev_in
 
 struct backing_dev_info noop_backing_dev_info = {
 	.name		= "noop",
+	.capabilities	= BDI_CAP_NO_ACCT_AND_WRITEBACK,
 };
 EXPORT_SYMBOL_GPL(noop_backing_dev_info);
 
@@ -254,6 +255,7 @@ static int __init default_bdi_init(void)
 	err = bdi_init(&default_backing_dev_info);
 	if (!err)
 		bdi_register(&default_backing_dev_info, NULL, "default");
+	err = bdi_init(&noop_backing_dev_info);
 
 	return err;
 }


