Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782Ab0LAG2Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 01:28:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167Ab0LAG2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 01:28:24 -0500
Message-ID: <4CF5EC28.6060402@redhat.com>
Date: Wed, 01 Dec 2010 14:33:12 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Shredder/3.0.4
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [Patch] debugfs: remove module_exit()
References: <20101109092449.6284.90481.sendpatchset@localhost.localdomain> <20101201013547.GA19390@kroah.com>
In-Reply-To: <20101201013547.GA19390@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/10 09:35, Greg KH wrote:
> On Tue, Nov 09, 2010 at 04:19:58AM -0500, Amerigo Wang wrote:
>> debugfs can't be a module, so module_exit() is meaningless
>> for it.
>>
>> Signed-off-by: WANG Cong<amwang@redhat.com>
>>
>> ---
>> diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
>> index 37a8ca7..d38c88f 100644
>> --- a/fs/debugfs/inode.c
>> +++ b/fs/debugfs/inode.c
>> @@ -13,9 +13,6 @@
>>    *
>>    */
>>
>> -/* uncomment to get debug messages from the debug filesystem, ah the irony. */
>> -/* #define DEBUG */
>
> Why did you remove these lines?  They don't pertain to this patch.

These lines are obsolete.


>
>> -
>>   #include<linux/module.h>
>>   #include<linux/fs.h>
>>   #include<linux/mount.h>
>> @@ -540,17 +537,5 @@ static int __init debugfs_init(void)
>>
>>   	return retval;
>>   }
>> -
>> -static void __exit debugfs_exit(void)
>> -{
>> -	debugfs_registered = false;
>> -
>> -	simple_release_fs(&debugfs_mount,&debugfs_mount_count);
>> -	unregister_filesystem(&debug_fs_type);
>> -	kobject_put(debug_kobj);
>> -}
>
> When the code is built into the kernel, the __exit function should go
> away, so this isn't costing us any extra memory, right?


Perhaps, but this can still reduce the vmlinux size, right?

>
> And debugfs used to be able to be built as a module, perhaps it will be
> in the future?  I don't think this patch is really needed.
>

Huh? Wasn't it a module before?

I think the problem is tracers use debugfs, it needs to depends on DEBUGFS=y.

Thanks.
