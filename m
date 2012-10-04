Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933987Ab2JDVWj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:22:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45178 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933969Ab2JDVWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:22:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Matthieu Castet <matthieu.castet@parrot.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [ 45/58] UBI: erase free PEB with bitflip in EC header
Date: Thu,  4 Oct 2012 14:19:52 -0700
Message-Id: <20121004210641.147222378@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121004210635.449598766@linuxfoundation.org>
References: <20121004210635.449598766@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu CASTET <matthieu.castet@parrot.com>

commit 193819cf2e6e395b1e1be2d36785dc5563a6edca upstream.

Without this patch, these PEB are not scrubbed until we put data in them.
Bitflip can accumulate latter and we can loose the EC header (but VID header
should be intact and allow to recover data).

Signed-off-by: Matthieu Castet <matthieu.castet@parrot.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/ubi/attach.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/ubi/attach.c
+++ b/drivers/mtd/ubi/attach.c
@@ -975,7 +975,7 @@ static int scan_peb(struct ubi_device *u
 			return err;
 		goto adjust_mean_ec;
 	case UBI_IO_FF:
-		if (ec_err)
+		if (ec_err || bitflips)
 			err = add_to_list(ai, pnum, UBI_UNKNOWN,
 					  UBI_UNKNOWN, ec, 1, &ai->erase);
 		else


