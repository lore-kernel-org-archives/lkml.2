Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651Ab1AaLlf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 06:41:35 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59139 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755551Ab1AaLle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 06:41:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references:mime-version:content-type:content-transfer-encoding;
        b=oPl56TOX0ld5SMvYn9DCwusxMUgUn4DInWMfKBlTXIjD8K4xzPXMBfK8+gL5TdY/NH
         mwIl/dsvVmzI4LYVzElCVk0Z3yO7BRDY/2uO0/sn4wAbTB9AsQvSb+edTPbxW0UYpVbV
         Wb198JyV3Mc7yLzrp11cbxhpDmM5JL1xWyMmo=
From: Pavel Shilovsky <piastry@etersoft.ru>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Steve French <smfrench@gmail.com>,
        Suresh Jayaraman <sjayaraman@suse.de>
Cc: linux-cifs@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jeff Layton <jlayton@redhat.com>
Subject: [PATCH] cifs: fix compiler warning about incompatible pointer type (try #2)
Date: Mon, 31 Jan 2011 14:41:23 +0300
Message-Id: <1296474083-18350-1-git-send-email-piastry@etersoft.ru>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <4D4693CF.9090903@suse.de>
References: <4D4693CF.9090903@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/cifs/file.c: In function ‘cifs_iovec_write’:
fs/cifs/file.c:1740:9: warning: passing argument 6 of ‘CIFSSMBWrite2’ from incompatible pointer type
fs/cifs/cifsproto.h:343:12: note: expected ‘unsigned int *’ but argument is of type ‘size_t *’

Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>
Signed-off-by: Pavel Shilovsky <piastry@etersoft.ru>
---
 fs/cifs/file.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 0de17c1..4940bac 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1667,9 +1667,9 @@ static ssize_t
 cifs_iovec_write(struct file *file, const struct iovec *iov,
 		 unsigned long nr_segs, loff_t *poffset)
 {
-	size_t total_written = 0, written = 0;
-	unsigned long num_pages, npages;
-	size_t copied, len, cur_len, i;
+	unsigned int written = 0;
+	unsigned long num_pages, npages, i;
+	size_t copied, len, cur_len, total_written = 0;
 	struct kvec *to_send;
 	struct page **pages;
 	struct iov_iter it;
-- 
1.7.1

