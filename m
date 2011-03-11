Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721Ab1CKTSx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 14:18:53 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:60143 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753256Ab1CKTSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 14:18:50 -0500
Message-ID: <4D7A7598.4020301@kernel.dk>
Date: Fri, 11 Mar 2011 20:18:48 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for March 11 (block/mm/fs)
References: <20110311184115.33404b77.sfr@canb.auug.org.au> <20110311095325.10ec7383.randy.dunlap@oracle.com>
In-Reply-To: <20110311095325.10ec7383.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-11 18:53, Randy Dunlap wrote:
> On Fri, 11 Mar 2011 18:41:15 +1100 Stephen Rothwell wrote:
> 
>> Hi all,
>>
>> Changes since 20110310:
>>
>> The block tree lost its build failure but gained another for which I
>> applied a patch.
> 
> 
> When CONFIG_BLOCK is not enabled:
> 
> mm/filemap.c:1257: error: storage size of 'plug' isn't known
> mm/filemap.c:2450: error: storage size of 'plug' isn't known
> mm/readahead.c:112: error: storage size of 'plug' isn't known
> fs/aio.c:1625: error: storage size of 'plug' isn't known

Thanks Randy, I fixed it up.

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 91fa428..16a902f 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1297,15 +1297,18 @@ static inline long nr_blockdev_pages(void)
 	return 0;
 }
 
-static inline void blk_start_plug(struct list_head *list)
+struct blk_plug {
+};
+
+static inline void blk_start_plug(struct blk_plug *plug)
 {
 }
 
-static inline void blk_finish_plug(struct list_head *list)
+static inline void blk_finish_plug(struct blk_plug *plug)
 {
 }
 
-static inline void blk_flush_plug(struct task_struct *tsk)
+static inline void blk_flush_plug(struct task_struct *task)
 {
 }
 

-- 
Jens Axboe

