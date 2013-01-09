Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933616Ab3AIVTp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:19:45 -0500
Received: from mail.kernel.org ([198.145.19.201]:42693 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933557Ab3AIUjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:39:23 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Yanchuan Nian <ycnian@gmail.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 051/123] pnfs: Increase the refcount when LAYOUTGET fails the first time
Date: Wed,  9 Jan 2013 12:34:50 -0800
Message-Id: <20130109201505.093611557@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201458.392601412@linuxfoundation.org>
References: <20130109201458.392601412@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yanchuan Nian <ycnian@gmail.com>

commit 39e88fcfb1d5c6c4b1ff76ca2ab76cf449b850e8 upstream.

The layout will be set unusable if LAYOUTGET fails. Is it reasonable to
increase the refcount iff LAYOUTGET fails the first time?

Signed-off-by: Yanchuan Nian <ycnian@gmail.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/pnfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -254,7 +254,7 @@ static void
 pnfs_layout_set_fail_bit(struct pnfs_layout_hdr *lo, int fail_bit)
 {
 	lo->plh_retry_timestamp = jiffies;
-	if (test_and_set_bit(fail_bit, &lo->plh_flags))
+	if (!test_and_set_bit(fail_bit, &lo->plh_flags))
 		atomic_inc(&lo->plh_refcount);
 }
 


