Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652Ab2EREbJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 00:31:09 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:61892 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415Ab2EREbH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 00:31:07 -0400
MIME-Version: 1.0
In-Reply-To: <4FB5C76F.6090504@huawei.com>
References: <CAFeW=pZcqnybTeMQPEMUguAwwgqpM1Hap2Dh3K-5majfYqMTaA@mail.gmail.com>
	<CAFeW=pZ-HZKyBALRZVo=PeWUoaEk39QUSoMsV-1K5CBgcVUMeA@mail.gmail.com>
	<4FB5C76F.6090504@huawei.com>
Date: Fri, 18 May 2012 12:31:06 +0800
Message-ID: <CAFeW=patEo56jXmyO6EPkDOf4oBwk1kaNE8OQASZHK-3d3zhZA@mail.gmail.com>
Subject: Re: cgroup: denying device doesn't work with 'rw' mode string
From: Amos Kong <kongjianjun@gmail.com>
To: Li Zefan <lizefan@huawei.com>
Cc: serue@us.ibm.com, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        tj@kernel.org, jmorris@namei.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 11:52 AM, Li Zefan <lizefan@huawei.com> wrote:
> Amos Kong wrote:
>
>> CC: Li Zefan <lizf@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>, jmorris@namei.org
>>
>> On Sat, Oct 15, 2011 at 8:39 AM, Amos Kong <kongjianjun@gmail.com> wrote:
>>> # mount -t cgroup -o devices none /cgroup
>>> # mkdir /cgroups/devices
>>> # ls -l /dev/vg/lv
>>> lrwxrwxrwx. 1 root root 7 Oct 14 19:03 /dev/vg/lv -> ../dm-3
>>> # ls -l /dev/dm-3
>>> brw-rw----. 1 root disk 253, 3 Oct 14 19:03 /dev/dm-3


>>> ------- test1
>>> deny read-write permission of dm-3, but it doesn't effect.
>>>
>>> # echo a > devices/devices.allow
>>> # echo 'b 253:2 rw' > devices.deny
>
>
> 253:2 ??

sorry, typo

# echo 'b 253:3 rw' > devices.deny      # But read-write permission is
not denied

>>>                ^^
>>> # echo $$ > task
>>> # dd if=/dev/zero of=/dev/dm-3 bs=1M count=1
>>> can write to /dev/dm-3 successfully  (problem exists)
>>>
>>> ------- test2
>>> # echo a > devices/devices.allow
>>> # echo 'b 253:3 rwm' > devices/devices.deny
>
>
> 253:3 !!
>
>>>                ^^^
>>> # echo $$ > task
>>> # dd if=/dev/zero of=/dev/dm-3 bs=1M count=1
>>> couldn't write to /dev/dm-3 successfully
