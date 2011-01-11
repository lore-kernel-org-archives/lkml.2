Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413Ab1AKXz0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 18:55:26 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51541 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752122Ab1AKXzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 18:55:25 -0500
Date: Tue, 11 Jan 2011 15:55:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
        Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 1/4] scatterlist: new helper functions
Message-Id: <20110111155511.bcb90254.akpm@linux-foundation.org>
In-Reply-To: <20110111155124.ee61cd7f.rdunlap@xenotime.net>
References: <1294788975-19584-1-git-send-email-maximlevitsky@gmail.com>
	<1294788975-19584-2-git-send-email-maximlevitsky@gmail.com>
	<20110111155124.ee61cd7f.rdunlap@xenotime.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Jan 2011 15:51:24 -0800
Randy Dunlap <rdunlap@xenotime.net> wrote:

> >  /**
> > + * sg_advance - advance scatterlist by 'consumed' bytes
> > + * @sg - the current sg entry
> > + * @consumed - how much bytes to advance
> 
> kernel-doc notation for parameters is like so:

I think I fixed most of this.  Probably missed some though.

Teach checkpatch to check kerneldoc ;)



From: Andrew Morton <akpm@linux-foundation.org>

fix general disaster in code comments

Cc: Alex Dubov <oakad@yahoo.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/scatterlist.c |   31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff -puN lib/scatterlist.c~scatterlist-new-helper-functions-fix lib/scatterlist.c
--- a/lib/scatterlist.c~scatterlist-new-helper-functions-fix
+++ a/lib/scatterlist.c
@@ -41,7 +41,7 @@ EXPORT_SYMBOL(sg_next);
 /**
  * sg_advance - advance scatterlist by 'consumed' bytes
  * @sg - the current sg entry
- * @consumed - how much bytes to advance
+ * @consumed - how many bytes to advance
  *
  */
 struct scatterlist *sg_advance(struct scatterlist *sg, int consumed)
@@ -76,8 +76,8 @@ EXPORT_SYMBOL(sg_advance);
  * sg_nents - calculate number of sg entries in sg list
  * @sg - the current sg entry
  *
- * Allows to calculate dynamicly the lenght of the sg table, based on
- * assumption that last entry is NULL
+ * Allows to calculate aldynamicly the length of the sg table, based on an
+ * assumption that the last entry is NULL
  */
 int sg_nents(struct scatterlist *sg)
 {
@@ -92,11 +92,11 @@ int sg_nents(struct scatterlist *sg)
 EXPORT_SYMBOL(sg_nents);
 
 /**
- * sg_total_len - calculate total lenght of scatterlist
+ * sg_total_len - calculate total length of scatterlist
  * @sg - the current sg entry
  *
- * Dynamicly calculate total number of bytes in a sg list
- * based on assumption that list ends with a NULL entry
+ * Dynamically calculate total number of bytes in a sg list
+ * based on an assumption that the list ends with a NULL entry
  */
 int sg_total_len(struct scatterlist *sg)
 {
@@ -182,8 +182,14 @@ void sg_init_one(struct scatterlist *sg,
 EXPORT_SYMBOL(sg_init_one);
 
 /**
- * sg_copy - copies sg entries from sg_from to sg_to, such
- * as sg_to covers first 'len' bytes from sg_from.
+ * sg_copy - copy sg entries
+ * @sg_from: source
+ * @sg_to: destination
+ *
+ * Copies from @sg_from to @sg_to.  @sg_to covers first 'len' bytes from
+ * @sg_from.
+ *
+ * Returns zero on success, else a -ve errno.
  */
 int sg_copy(struct scatterlist *sg_from, struct scatterlist *sg_to, int len)
 {
@@ -616,13 +622,12 @@ size_t sg_copy_to_buffer(struct scatterl
 }
 EXPORT_SYMBOL(sg_copy_to_buffer);
 
-
 /**
- * sg_compare_to_buffer - compare contents of the data pointeted by sg table
+ * sg_compare_to_buffer - compare contents of the data covered by an sg table
  * to a kernel ram buffer
- * @sg - the current sg entry
- * @buffer - linear buffer to compare with
- * @len - lenght of that buffer
+ * @sg: the current sg entry
+ * @buffer: linear buffer to compare with
+ * @len: length of that buffer
  */
 bool sg_compare_to_buffer(struct scatterlist *sg, u8 *buffer, size_t len)
 {
_

