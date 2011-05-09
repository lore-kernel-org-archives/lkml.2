Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab1EIRiu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 13:38:50 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:55570 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab1EIRit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 13:38:49 -0400
Date: Mon, 9 May 2011 10:38:26 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH -next] fs/partitions: fix printk format warning
Message-Id: <20110509103826.58551948.randy.dunlap@oracle.com>
In-Reply-To: <20110509152401.cc001ad6.sfr@canb.auug.org.au>
References: <20110509152401.cc001ad6.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4DC826A1.0080:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

fs/partitions/check.c:263: warning: format '%u' expects type 'unsigned int', but argument 3 has type 'long long unsigned int'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 fs/partitions/check.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20110509.orig/fs/partitions/check.c
+++ linux-next-20110509/fs/partitions/check.c
@@ -257,7 +257,7 @@ ssize_t part_discard_alignment_show(stru
 	struct hd_struct *p = dev_to_part(dev);
 	struct gendisk *disk = dev_to_disk(dev);
 
-	return sprintf(buf, "%u\n",
+	return sprintf(buf, "%llu\n",
 		       (unsigned long long)queue_limit_discard_alignment(
 							&disk->queue->limits,
 							p->start_sect));
