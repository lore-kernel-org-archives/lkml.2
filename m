Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751075Ab1GSAhs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 20:37:48 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55685 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750758Ab1GSAhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 20:37:47 -0400
Message-ID: <4E24D19F.3030109@cn.fujitsu.com>
Date: Tue, 19 Jul 2011 08:36:47 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: FNST
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110322 Red Hat/3.1.9-3.el6_0 Thunderbird/3.1.9
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Wanlong Gao <wanlong.gao@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] fs:update the NOTE of the file_operations structure
References: <1311009790-10312-1-git-send-email-wanlong.gao@gmail.com> <20110718172744.GA15785@infradead.org>
In-Reply-To: <20110718172744.GA15785@infradead.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-19 08:36:55,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-19 08:36:57,
	Serialize complete at 2011-07-19 08:36:57
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2011 01:27 AM, Christoph Hellwig wrote:
>>   /*
>>    * NOTE:
>>    * all file operations except setlease can be called without
>> - * the big kernel lock held in all filesystems.
>> + * the special spin_lock file_lock_lock held in all filesystems.
>>    */
>>   struct file_operations {
>>   	struct module *owner;
>
> I'd just remove the comment entirely.
>
 From 765a06af4b8b4b67238e896fb6b82270d765195d Mon Sep 17 00:00:00 2001
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Date: Tue, 19 Jul 2011 08:30:17 +0800
Subject: [PATCH] fs:remove the out-of-date NOTE of file_operations structure

Big kernel lock had been removed and setlease now use the lock_flocks()
to hold a special spin lock file_lock_lock by Matthew.
So just remove the out-of-date NOTE.

Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
---
  include/linux/fs.h |    5 -----
  1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index b5b9792..67b2b21 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1538,11 +1538,6 @@ struct block_device_operations;
  #define HAVE_COMPAT_IOCTL 1
  #define HAVE_UNLOCKED_IOCTL 1

-/*
- * NOTE:
- * all file operations except setlease can be called without
- * the big kernel lock held in all filesystems.
- */
  struct file_operations {
  	struct module *owner;
  	loff_t (*llseek) (struct file *, loff_t, int);
-- 
1.7.6


-- 
Thanks
Best Regards
Wanlong Gao
