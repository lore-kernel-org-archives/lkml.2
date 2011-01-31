Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab1AaMJt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 07:09:49 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41963 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190Ab1AaMJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 07:09:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references:mime-version:content-type:content-transfer-encoding;
        b=aqxS/yjlgz4P5KdbH3ec6+fBj89XPKeL7F3tMCoo1oQqOwdiYTXmslvsqvHux2utCP
         TMlsq3pqDsCNCL108aM4GHl77q6ok340NS8wo5QVM9F0wvaEde4mIMU2JFHjuPrCw7K2
         DqZm3tI8srvCsObrqG2oNDTTidLSxK8RpKq/Q=
From: Pavel Shilovsky <piastry@etersoft.ru>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Steve French <smfrench@gmail.com>,
        Suresh Jayaraman <sjayaraman@suse.de>
Cc: linux-cifs@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jeff Layton <jlayton@redhat.com>
Subject: [PATCH] cifs: fix compiler warning about incompatible pointer type (try #3)
Date: Mon, 31 Jan 2011 15:09:39 +0300
Message-Id: <1296475779-19357-1-git-send-email-piastry@etersoft.ru>
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
 fs/cifs/file.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 0de17c1..d8338e7 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1667,9 +1667,10 @@ static ssize_t
 cifs_iovec_write(struct file *file, const struct iovec *iov,
 		 unsigned long nr_segs, loff_t *poffset)
 {
-	size_t total_written = 0, written = 0;
-	unsigned long num_pages, npages;
-	size_t copied, len, cur_len, i;
+	unsigned int written;
+	ssize_t total_written = 0;
+	unsigned long num_pages, npages, i;
+	size_t copied, len, cur_len;
 	struct kvec *to_send;
 	struct page **pages;
 	struct iov_iter it;
@@ -1825,7 +1826,8 @@ cifs_iovec_read(struct file *file, const struct iovec *iov,
 {
 	int rc;
 	int xid;
-	unsigned int total_read, bytes_read = 0;
+	ssize_t total_read;
+	unsigned int bytes_read = 0;
 	size_t len, cur_len;
 	int iov_offset = 0;
 	struct cifs_sb_info *cifs_sb;
-- 
1.7.1

