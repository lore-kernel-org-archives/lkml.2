Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757829Ab1E3S4z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 14:56:55 -0400
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:51962 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751337Ab1E3S4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 14:56:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=nanometrics.ca; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ot58/5M6sSl6cpdV1gcILxDkFOBMM/kC8CxOj7fo49KFbHtt/99t+Zki1tZ6dZZMlz
         TJJsrjuqiJNIh1tXMpweiMHZ8lUBtwFEKIyZaQRdH3SV4J3Sp+B+svKapzG/9AgcB4r8
         qLW6ZdM78A/e9E1p8Lzqb+a0qMlrvkQXCwPsw=
From: Ben Gardiner <bengardiner@nanometrics.ca>
To: Artem Bityutskiy <dedekind1@gmail.com>,
        Adrian Hunter <adrian.hunter@nokia.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Matthew L. Creech" <mlcreech@gmail.com>
Subject: [PATCH 1/3] UBIFS: assert no fixup when writing a node
Date: Mon, 30 May 2011 14:56:14 -0400
Message-Id: <4a63933a3365daf8d1ec38d22c9029a949f3eccd.1306780983.git.bengardiner@nanometrics.ca>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <cover.1306780983.git.bengardiner@nanometrics.ca>
References: <cover.1306780983.git.bengardiner@nanometrics.ca>
In-Reply-To: <cover.1306780983.git.bengardiner@nanometrics.ca>
References: <cover.1306780983.git.bengardiner@nanometrics.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current free space fixup can result in some writing to the UBI volume
when the space_fixup flag is set.

To catch instances where UBIFS is writing to the NAND while the space_fixup
flag is set, add an assert to ubifs_write_node().

Signed-off-by: Ben Gardiner <bengardiner@nanometrics.ca>

---
 fs/ubifs/io.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ubifs/io.c b/fs/ubifs/io.c
index 166951e..db298de 100644
--- a/fs/ubifs/io.c
+++ b/fs/ubifs/io.c
@@ -763,6 +763,8 @@ int ubifs_write_node(struct ubifs_info *c, void *buf, int len, int lnum,
 	if (c->ro_error)
 		return -EROFS;
 
+	ubifs_assert(!c->space_fixup);
+
 	ubifs_prepare_node(c, buf, len, 1);
 	err = ubi_leb_write(c->ubi, lnum, buf, offs, buf_len, dtype);
 	if (err) {
-- 
1.7.4.1

