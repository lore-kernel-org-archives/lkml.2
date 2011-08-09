Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252Ab1HIHOQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 03:14:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31597 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241Ab1HIHOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 03:14:15 -0400
Message-ID: <4E40DE33.1070208@redhat.com>
Date: Tue, 09 Aug 2011 15:13:55 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc14 Thunderbird/3.1.11
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Clements <Paul.Clements@steeleye.com>,
        Jiri Kosina <trivial@kernel.org>
Subject: Re: [PATCH] nbd: some trivial improvements
References: <1312794004-22047-1-git-send-email-amwang@redhat.com> <1312821425.1643.11.camel@Joe-Laptop>
In-Reply-To: <1312821425.1643.11.camel@Joe-Laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年08月09日 00:37, Joe Perches 写道:
> On Mon, 2011-08-08 at 17:00 +0800, Amerigo Wang wrote:
>> This patch 1) uses task_pid_nr(current) to get the pid of current process,
>>   2) replaces sysfs_create_file() with device_create_file(), 3) lower
>> the loglevel of an error message.
>
> Just trivia:
>
>> diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
> []
>> @@ -405,10 +405,10 @@ static int nbd_do_it(struct nbd_device *lo)
>>
>>   	BUG_ON(lo->magic != LO_MAGIC);
>>
>> -	lo->pid = current->pid;
>> -	ret = sysfs_create_file(&disk_to_dev(lo->disk)->kobj,&pid_attr.attr);
>> +	lo->pid = task_pid_nr(current);
>> +	ret = device_create_file(disk_to_dev(lo->disk),&pid_attr);
>>   	if (ret) {
>> -		printk(KERN_ERR "nbd: sysfs_create_file failed!");
>> +		printk(KERN_ERR "nbd: device_create_file failed!");
>
> Missing "\n".
>

Ok, I didn't notice this, will fix it.

Thanks.
