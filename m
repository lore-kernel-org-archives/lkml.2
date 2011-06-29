Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524Ab1F2SPD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 14:15:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757463Ab1F2SPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 14:15:01 -0400
Message-ID: <4E0B6B96.7020606@redhat.com>
Date: Wed, 29 Jun 2011 14:14:46 -0400
From: Josef Bacik <josef@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: push i_mutex and filemap_write_and_wait down into
 ->fsync() handlers
References: <1309370716-12235-1-git-send-email-josef@redhat.com> <20110629180939.GA9934@infradead.org>
In-Reply-To: <20110629180939.GA9934@infradead.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2011 02:09 PM, Christoph Hellwig wrote:
>> -int blkdev_fsync(struct file *filp, int datasync)
>> +int blkdev_fsync(struct file *filp, loff_t start, loff_t end, int datasync)
>>  {
>>  	struct inode *bd_inode = filp->f_mapping->host;
>>  	struct block_device *bdev = I_BDEV(bd_inode);
>> @@ -389,14 +389,10 @@ int blkdev_fsync(struct file *filp, int datasync)
>>  	 * i_mutex and doing so causes performance issues with concurrent
>>  	 * O_SYNC writers to a block device.
>>  	 */
>> -	mutex_unlock(&bd_inode->i_mutex);
>> -
> 
> Now that i_mutex on entry isn't held the comment above can be removed.
> 

The comment is still useful since it states why we don't take the
i_mutex at all, so I think it's still valuable.  Thanks,

Josef
