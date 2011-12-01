Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223Ab1LAAY2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 19:24:28 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:64607 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752462Ab1LAAY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 19:24:27 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlgHAFnI1k4YNOMa/2dsb2JhbABEmwIZj3mBBoFyAQEFOB4GHAEQCwsDBwMJFg8JAwIBAgERFh4GDQEFAgKvKYdYPYh4iyAEiCiCD4oghUODR4FQh1Q
X-IronPort-AV: E=Sophos;i="4.71,274,1320642000"; 
   d="scan'208";a="150319625"
Message-ID: <4ED6C939.9050403@gmail.com>
Date: Wed, 30 Nov 2011 19:24:25 -0500
From: Woody Suwalski <terraluna977@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0.1) Gecko/20111121 Firefox/8.0.1 SeaMonkey/2.5
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: yanhong <tempname2@hotmail.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] init/do_mounts.c : Create /root if it does not exits
References: <COL118-W62A0038F6E85B96D4881F6F6CC0@phx.gbl> <20111130125555.85ac54e7.akpm@linux-foundation.org>
In-Reply-To: <20111130125555.85ac54e7.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sat, 26 Nov 2011 08:34:18 +0000
> yanhong<tempname2@hotmail.com>  wrote:
>
>> From: YanHong<tempname2@hotmail.com>
>>
>> If someone supplies an initramfs without /root in it, and we fail to execute rdinit, we will try to mount root device and fail, for the mount point does not exits.
>>
>> But we get error message "VFS: Cannot open root device". It's confusing.
>>
>> We can give more detailed error message, or we can go further: if /root does not exits,  create one.
>>
> I really don't know enough about initramfs usage to know if this is a
> good or bad thing.  Can anyone else comment?
>
>> --- a/init/do_mounts.c
>> +++ b/init/do_mounts.c
>> @@ -350,6 +350,9 @@ void __init mount_block_root(char *name, int flags)
>>          const char *b = name;
>>   #endif
>>
>> +       if (sys_access((const char __user *) "/root", 0) != 0)
>> +               sys_mkdir((const char __user *) "/root", 0700);
>> +
>>          get_fs_names(fs_names);
>>   retry:
>>          for (p = fs_names; *p; p += strlen(p)+1) {
> I suppose we could remove the sys_access() check and just run mkdir(),
> which will fail to do anything if /root already exists.
>
I think that it may lead to more problems... If I make mistake in the 
initramfs or forget to make one I want to know about it, rather then see 
some unexpected root and system maybe partially booting.
Unless we start printing a highly visible warning along? Still - it is 
cleaner to simply stop boot (IMHO).

Woody

