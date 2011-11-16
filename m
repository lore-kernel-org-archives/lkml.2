Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932874Ab1KPBPZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 20:15:25 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47176 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757326Ab1KPBPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 20:15:17 -0500
Message-ID: <4EC2FF8A.2050804@jp.fujitsu.com>
Date: Tue, 15 Nov 2011 19:10:50 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: dave@gnu.org
CC: akpm@linux-foundation.org, jslaby@suse.cz, gaowanlong@cn.fujitsu.com,
        npiggin@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipc/mqueue: simplify reading msgqueue limit
References: <1320345109.3188.3.camel@offbook> <1320704156.3009.0.camel@offbook>
In-Reply-To: <1320704156.3009.0.camel@offbook>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/7/2011 5:15 PM, Davidlohr Bueso wrote:
> ping?
> 
> On Thu, 2011-11-03 at 15:31 -0300, Davidlohr Bueso wrote:
>> From: Davidlohr Bueso <dave@gnu.org>
>>
>> Because the current task is being used to get the limit, we can simply use rlimit() instead of task_rlimit().
>>
>> Signed-off-by: Davidlohr Bueso <dave@gnu.org>

Sorry for the delay.

	Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



>> ---
>>  ipc/mqueue.c |    3 +--
>>  1 files changed, 1 insertions(+), 2 deletions(-)
>>
>> diff --git a/ipc/mqueue.c b/ipc/mqueue.c
>> index 2e0ecfc..c0e4fbb 100644
>> --- a/ipc/mqueue.c
>> +++ b/ipc/mqueue.c
>> @@ -127,7 +127,6 @@ static struct inode *mqueue_get_inode(struct super_block *sb,
>>  
>>  	if (S_ISREG(mode)) {
>>  		struct mqueue_inode_info *info;
>> -		struct task_struct *p = current;
>>  		unsigned long mq_bytes, mq_msg_tblsz;
>>  
>>  		inode->i_fop = &mqueue_file_operations;
>> @@ -158,7 +157,7 @@ static struct inode *mqueue_get_inode(struct super_block *sb,
>>  
>>  		spin_lock(&mq_lock);
>>  		if (u->mq_bytes + mq_bytes < u->mq_bytes ||
>> -		    u->mq_bytes + mq_bytes > task_rlimit(p, RLIMIT_MSGQUEUE)) {
>> +		    u->mq_bytes + mq_bytes > rlimit(RLIMIT_MSGQUEUE)) {
>>  			spin_unlock(&mq_lock);
>>  			/* mqueue_evict_inode() releases info->messages */
>>  			ret = -EMFILE;
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

