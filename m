Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213Ab1LNNem (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 08:34:42 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:43932 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859Ab1LNNel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 08:34:41 -0500
X-Authority-Analysis: v=2.0 cv=FIuZNpUs c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=ewjKGVC-4pQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=BZMhDRmfmsuKveKUUEsA:9 a=ECpTwJHErp6HUt4qVnIA:7 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1323869678.23971.19.camel@gandalf.stny.rr.com>
Subject: md: Fix userspace free_pages() macro
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: NeilBrown <neilb@suse.de>, Dan Williams <dan.j.williams@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Date: Wed, 14 Dec 2011 08:34:38 -0500
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While using etags to find free_pages(), I stumbled across this debug
definition of free_pages() that is to be used while debugging some raid
code in userspace. The __get_free_pages() allocates the correct size,
but the free_pages() does not match. free_pages(), like
__get_free_pages(), takes an order and not a size.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/include/linux/raid/pq.h b/include/linux/raid/pq.h
index 2b59cc8..53272e9 100644
--- a/include/linux/raid/pq.h
+++ b/include/linux/raid/pq.h
@@ -132,7 +132,7 @@ void raid6_dual_recov(int disks, size_t bytes, int faila, int failb,
 						     PROT_READ|PROT_WRITE,   \
 						     MAP_PRIVATE|MAP_ANONYMOUS,\
 						     0, 0))
-# define free_pages(x, y)	munmap((void *)(x), (y)*PAGE_SIZE)
+# define free_pages(x, y)	munmap((void *)(x), PAGE_SIZE << (y))
 
 static inline void cpu_relax(void)
 {


