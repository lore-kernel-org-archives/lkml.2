Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031054Ab2ERD4w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 23:56:52 -0400
Received: from szxga01-in.huawei.com ([58.251.152.64]:47149 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030769Ab2ERD4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 23:56:48 -0400
Date: Fri, 18 May 2012 11:52:15 +0800
From: Li Zefan <lizefan@huawei.com>
Subject: Re: cgroup: denying device doesn't work with 'rw' mode string
In-reply-to: <CAFeW=pZ-HZKyBALRZVo=PeWUoaEk39QUSoMsV-1K5CBgcVUMeA@mail.gmail.com>
X-Originating-IP: [10.166.88.128]
To: Amos Kong <kongjianjun@gmail.com>
Cc: serue@us.ibm.com, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        tj@kernel.org, jmorris@namei.org
Message-id: <4FB5C76F.6090504@huawei.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120312
 Thunderbird/11.0
X-CFilter-Loop: Reflected
References: <CAFeW=pZcqnybTeMQPEMUguAwwgqpM1Hap2Dh3K-5majfYqMTaA@mail.gmail.com>
 <CAFeW=pZ-HZKyBALRZVo=PeWUoaEk39QUSoMsV-1K5CBgcVUMeA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amos Kong wrote:

> CC: Li Zefan <lizf@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>, jmorris@namei.org
> 
> On Sat, Oct 15, 2011 at 8:39 AM, Amos Kong <kongjianjun@gmail.com> wrote:
>> # mount -t cgroup -o devices none /cgroup
>> # mkdir /cgroups/devices
>> # ls -l /dev/vg/lv
>> lrwxrwxrwx. 1 root root 7 Oct 14 19:03 /dev/vg/lv -> ../dm-3
>> # ls -l /dev/dm-3
>> brw-rw----. 1 root disk 253, 3 Oct 14 19:03 /dev/dm-3
>>
>>
>> ------- test1
>> deny read-write permission of dm-3, but it doesn't effect.
>>
>> # echo a > devices/devices.allow
>> # echo 'b 253:2 rw' > devices.deny


253:2 ??

>>                ^^
>> # echo $$ > task
>> # dd if=/dev/zero of=/dev/dm-3 bs=1M count=1
>> can write to /dev/dm-3 successfully  (problem exists)
>>
>> ------- test2
>> # echo a > devices/devices.allow
>> # echo 'b 253:3 rwm' > devices/devices.deny


253:3 !!

>>                ^^^
>> # echo $$ > task
>> # dd if=/dev/zero of=/dev/dm-3 bs=1M count=1
>> couldn't write to /dev/dm-3 successfully


