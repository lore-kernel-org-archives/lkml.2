Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026Ab1JKDBi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 23:01:38 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49210 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750739Ab1JKDBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 23:01:37 -0400
Message-ID: <4E93B1CE.4070908@cn.fujitsu.com>
Date: Tue, 11 Oct 2011 11:02:38 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: handai handai <handai.szj@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [Fwd: Re: cgroup umount bug]
References: <1318146066.2168.10.camel@handai-OptiPlex-780> <CAFj3OHVh391k5p2aXKP4R6YGEfCmm5GMOTnAMSpvbnyYzrNUDg@mail.gmail.com>
In-Reply-To: <CAFj3OHVh391k5p2aXKP4R6YGEfCmm5GMOTnAMSpvbnyYzrNUDg@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-10-11 10:59:50,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-10-11 10:59:51,
	Serialize complete at 2011-10-11 10:59:51
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=GB2312
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I'm not sure from what you write whether you're aware of this, but
>> to work around this, you can then
>>
>>  mount -t cgroup -o cpu /mnt
>>  for i in `cat /mnt/test/tasks`; do
>>  echo $i > /mnt/tasks
>>  done
>>  rmdir /mnt/test
>>  umount /mnt
>>
>> and now you can
>>
>>  mount -cgroup -o cpu,cpuset cgroup /mnt
>>
> 
> I know that I can bypass this problem by deleting subgroups before
> unmount. But there is no document mentioning that I should do this to
> avoid it. But even if there is, users may still directly umount it
> accidentally, then he should try to remember what he has done and back
> to the scene to make it up, or he may need to reboot his server to do
> another test : ( .

You can check /proc/cgroups:

# mount -t cgroup -o cpu,cpuset cgroup /mnt
# mkdir /mnt/sub
# umount /mnt
# cat /proc/cgroups 
#subsys_name    hierarchy       num_cgroups     enabled
cpuset  1       2       1
cpu     1       2       1
memory  0       1       1
devices 0       1       1
freezer 0       1       1
net_cls 0       1       1
blkio   0       1       1

> So, since there is nothing good to permit incompletely unmount, why
> not prevent the potential problem by prohibiting this behavior at
> first ?
> 
