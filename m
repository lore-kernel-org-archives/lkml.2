Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134Ab2AXCoo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:44:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50184 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932093Ab2AXCom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:44:42 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:28 2012
Message-Id: <20120124023928.519383105@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:34:32 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Richard Weinberger <richard@nod.at>,
        Artem Bityutskiy <Artem.Bityutskiy@linux.intel.com>
Subject: [052/129] UBI: fix nameless volumes handling
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 843
Lines: 31

From: Richard Weinberger <richard@nod.at>

commit 4a59c797a18917a5cf3ff7ade296b46134d91e6a upstream.

Currently it's possible to create a volume without a name. E.g:
ubimkvol -n 32 -s 2MiB -t static /dev/ubi0 -N ""

After that vtbl_check() will always fail because it does not permit
empty strings.

Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mtd/ubi/cdev.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/mtd/ubi/cdev.c
+++ b/drivers/mtd/ubi/cdev.c
@@ -632,6 +632,9 @@ static int verify_mkvol_req(const struct
 	if (req->alignment != 1 && n)
 		goto bad;
 
+	if (!req->name[0] || !req->name_len)
+		goto bad;
+
 	if (req->name_len > UBI_VOL_NAME_MAX) {
 		err = -ENAMETOOLONG;
 		goto bad;


