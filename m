Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079Ab0ECRIA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 13:08:00 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:65069 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755001Ab0ECRH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 13:07:57 -0400
Date: Mon, 3 May 2010 10:06:11 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org
Subject: [PATCH -next] power: fix block_io.c printk warning
Message-Id: <20100503100611.2ca63b58.randy.dunlap@oracle.com>
In-Reply-To: <20100503151619.f75e3a80.sfr@canb.auug.org.au>
References: <20100503151619.f75e3a80.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090203.4BDF02AE.0006:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warning in block_io.c:

kernel/power/block_io.c:41: warning: format '%ld' expects type 'long int', but argument 2 has type 'sector_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
---
 kernel/power/block_io.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20100503.orig/kernel/power/block_io.c
+++ linux-next-20100503/kernel/power/block_io.c
@@ -37,8 +37,8 @@ static int submit(int rw, struct block_d
 	bio->bi_end_io = end_swap_bio_read;
 
 	if (bio_add_page(bio, page, PAGE_SIZE, 0) < PAGE_SIZE) {
-		printk(KERN_ERR "PM: Adding page to bio failed at %ld\n",
-			sector);
+		printk(KERN_ERR "PM: Adding page to bio failed at %llu\n",
+			(unsigned long long)sector);
 		bio_put(bio);
 		return -EFAULT;
 	}
