Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab1BVScc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 13:32:32 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:8721 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754786Ab1BVScb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 13:32:31 -0500
Message-ID: <4D640133.9020901@caviumnetworks.com>
Date: Tue, 22 Feb 2011 10:32:19 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Kees Cook <kees.cook@canonical.com>
CC: linux-kernel@vger.kernel.org, Eugene Teo <eugeneteo@kernel.sg>,
        Ralph Campbell <infinipath@qlogic.com>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Miklos Szeredi <miklos@szeredi.hu>,
        "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>,
        Matthew Wilcox <matthew@wil.cx>, James Morris <jmorris@namei.org>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Eric Paris <eparis@parisplace.org>, Nick Piggin <npiggin@kernel.dk>,
        Arnd Bergmann <arnd@arndb.de>, Ian Campbell <ian.campbell@citrix.com>,
        Jarkko Sakkinen <ext-jarkko.2.sakkinen@nokia.com>,
        Tejun Heo <tj@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH 2/2] debugfs: only allow root access to debugging interfaces
References: <1298398198-18482-1-git-send-email-kees.cook@canonical.com> <1298398198-18482-2-git-send-email-kees.cook@canonical.com> <20110222181613.GU4000@outflux.net>
In-Reply-To: <20110222181613.GU4000@outflux.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Feb 2011 18:32:24.0984 (UTC) FILETIME=[D9CC1180:01CBD2BE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2011 10:16 AM, Kees Cook wrote:
> Har har, I forgot --compose to "git send-email".
>
> Anyway, with the continuing deluge of bugs in the "debug" filesystem, I
> would like to make that filesystem's root directory mode 0700 by default
> since it's filled with crazy stuff that regular users do not need to see.
>
> Better to try to just close the door completely on all the stuff in there.
> It is, after all, supposed to only be used for debugging, right?
>

It depends if you consider use of ftrace and kprobes 'debugging'.  In 
any event, you really have to be root to be able to manipulate them.

I can currently do 'cat /sys/kernel/debug/tracing/trace' as a normal 
user.  With your change I don't think it would be possible.  This is not 
something I often (ever) do, but it is a change.

David Daney


> -Kees
>
> On Tue, Feb 22, 2011 at 10:09:58AM -0800, Kees Cook wrote:
>> Block access to the potentially dangerous debugging interfaces in
>> the debugfs filesystem.
>>
>> Signed-off-by: Kees Cook<kees.cook@canonical.com>
>> ---
>>   fs/debugfs/inode.c |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
>> index 3cb33c3..83c61a3 100644
>> --- a/fs/debugfs/inode.c
>> +++ b/fs/debugfs/inode.c
>> @@ -133,7 +133,7 @@ static int debug_fill_super(struct super_block *sb, void *data, int silent)
>>   	static struct tree_descr debug_files[] = {{""}};
>>
>>   	return simple_fill_super(sb, DEBUGFS_MAGIC, debug_files,
>> -				 S_IWUSR | S_IRUGO | S_IXUGO);
>> +				 S_IRWXU);
>>   }
>>
>>   static struct dentry *debug_mount(struct file_system_type *fs_type,
>> --
>> 1.7.2.3
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/

