Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab2ASB5H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 20:57:07 -0500
Received: from mail.nudt.edu.cn ([61.187.54.11]:54829 "HELO nudt.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752828Ab2ASB5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 20:57:05 -0500
Date: Thu, 19 Jan 2012 09:44:36 +0800
From: "Li Wang" <liwang@nudt.edu.cn>
Subject: Re:Re: [PATCH] eCryptfs: infinite loop bug
To: ecryptfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Dustin Kirkland" <kirkland@canonical.com>,
        "Cong Wang" <xiyou.wangcong@gmail.com>,
        "Tyler Hicks" <tyhicks@canonical.com>
References: <12011815300568720b5d1587bb777fed0d5b016f0854@nudt.edu.cn>
 <4F16E4BC.5080100@gmail.com>
 <526922120.05125@eyou.net>
In-Reply-To: <526922120.05125@eyou.net>
Message-Id: <12011909443668a7a65ff897afc93db177848236f08f@nudt.edu.cn>
MIME-Version: 1.0
X-Mailer: eYou WebMail 5.0.3
X-Eyou-Client: 119.39.21.16
Content-Type: text/plain;
 charset="GBK"
X-Eyou-Sender: <liwang@nudt.edu.cn>
X-Eyou-MID: <1645b052a6b4eea81f839e1e612fc362>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q0J1vk0E027793



Hi,
  Thanks Cong Wang for the kind reminding regarding the patch format.
  We did notice that the total_remaining_zeroes need be revised as well, 
and the start_offset_in_page, num_bytes need not be revised (always smaller 
than PAGE_CACHE_SIZE, even the huge page size is supported, 
the 4G page size is not present in the current world?)
but we forget to include the revision for total_remaining_zeroes, so here comes the patch.

Cheers,
Li Wang

Signed-off-by: Li Wang <liwang@nudt.edu.cn>
               Yunchuan Wen <wenyunchuan@kylinos.com.cn>

---

--- a/fs/ecryptfs/read_write.c	2012-01-19 17:34:54.666940824 +0800
+++ b/fs/ecryptfs/read_write.c	2012-01-19 17:35:16.257940840 +0800
@@ -130,13 +130,13 @@ int ecryptfs_write(struct inode *ecryptf
 		pgoff_t ecryptfs_page_idx = (pos >> PAGE_CACHE_SHIFT);
 		size_t start_offset_in_page = (pos & ~PAGE_CACHE_MASK);
 		size_t num_bytes = (PAGE_CACHE_SIZE - start_offset_in_page);
-		size_t total_remaining_bytes = ((offset + size) - pos);
+		loff_t total_remaining_bytes = ((offset + size) - pos);
 
 		if (num_bytes > total_remaining_bytes)
 			num_bytes = total_remaining_bytes;
 		if (pos < offset) {
 			/* remaining zeros to write, up to destination offset */
-			size_t total_remaining_zeros = (offset - pos);
+			loff_t total_remaining_zeros = (offset - pos);
 
 			if (num_bytes > total_remaining_zeros)
 				num_bytes = total_remaining_zeros;





---------- Origin message ----------
>From£º"Tyler Hicks" <tyhicks@canonical.com>
>To£º"Cong Wang" <xiyou.wangcong@gmail.com>
>Subject£ºRe: [PATCH] eCryptfs: infinite loop bug
>Date£º2012-01-19 05:40:51

On 2012-01-18 23:26:52, Cong Wang wrote:
> On 01/18/2012 03:30 PM, Li Wang wrote:
> >Hi,
> > There is an infinite loop bug in eCryptfs, to make it present,
> >just truncate to generate a huge file (>= 4G) on a 32-bit machine
> >under the plain text foleder mounted with eCryptfs, a simple command
> >'truncate -s 4G dummy' is enough. Note: 4GB is smaller than 4G,
> >therefore the following command 'truncate -s 4GB dummy' will not trigger this bug.
> >The bug comes from a data overflow, the patch below fixes it.
> >
> >
>
> Hi,
>
> Your patch is not correctly generated, you need to make the diff on
> top of the source tree.
>
> Also, after reviewing the code, I think there are more places need
> to fix. Can you try my patch below?
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
