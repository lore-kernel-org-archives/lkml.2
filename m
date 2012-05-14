Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932745Ab2ENX43 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 19:56:29 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44945 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756346Ab2ENX42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 19:56:28 -0400
Message-ID: <4FB19B96.4010106@gmail.com>
Date: Tue, 15 May 2012 07:56:06 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext2: cleanup the comment for ext2_export_ops
References: <4FB0B0F4.3060908@gmail.com> <20120514095525.GD5353@quack.suse.cz>
In-Reply-To: <20120514095525.GD5353@quack.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012年05月14日 17:55, Jan Kara wrote:
> On Mon 14-05-12 15:15:00, Wang Sheng-Hui wrote:
>> ext2_export_ops gets more valued fields, not get_parent only.
>> Clean up the comment.
>   Um, I'd just remove the whole comment. It isn't particularly informative
> anyway - NULL meaning the default behavior is very common in kernel. And we
> really set about half of entries anyway...
> 
> 								Honza

Thanks, Honza.

Patch regenerated. Please check it.

>>
>> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
>> ---
>>  fs/ext2/super.c |    1 -
>>  1 files changed, 0 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
>> index e1025c7..640b4c6 100644
>> --- a/fs/ext2/super.c
>> +++ b/fs/ext2/super.c
>> @@ -359,7 +359,6 @@ static struct dentry *ext2_fh_to_parent(struct super_block *sb, struct fid *fid,
>>  /* Yes, most of these are left as NULL!!
>>   * A NULL value implies the default, which works with ext2-like file
>>   * systems, but can be improved upon.
>> - * Currently only get_parent is required.
>>   */
>>  static const struct export_operations ext2_export_ops = {
>>  	.fh_to_dentry = ext2_fh_to_dentry,
>> -- 
>> 1.7.1

>From 362925f80bdfb1c105e346f535c5e51c7359b550 Mon Sep 17 00:00:00 2001
From: Wang Sheng-Hui <shhuiw@gmail.com>
Date: Tue, 15 May 2012 07:53:46 +0800
Subject: [PATCH] ext2: remove the redundant comment for ext2_export_ops

Per Honza, It isn't particularly informative anyway - NULL
meaning the default behavior is very common in kernel. And we
really set about half of entries anyway.

Remove the whole comment for ext2_export_ops.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 fs/ext2/super.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index e1025c7..f9b0f41 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -356,11 +356,6 @@ static struct dentry *ext2_fh_to_parent(struct super_block *sb, struct fid *fid,
 				    ext2_nfs_get_inode);
 }
 
-/* Yes, most of these are left as NULL!!
- * A NULL value implies the default, which works with ext2-like file
- * systems, but can be improved upon.
- * Currently only get_parent is required.
- */
 static const struct export_operations ext2_export_ops = {
 	.fh_to_dentry = ext2_fh_to_dentry,
 	.fh_to_parent = ext2_fh_to_parent,
-- 
1.7.1

