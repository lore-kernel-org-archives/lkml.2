Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760059Ab2DKDeT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 23:34:19 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50028 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756162Ab2DKDeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 23:34:18 -0400
X-IronPort-AV: E=Sophos;i="4.75,403,1330876800"; 
   d="scan'208";a="4726663"
Message-ID: <4F84F7BC.102@cn.fujitsu.com>
Date: Wed, 11 Apr 2012 11:17:16 +0800
From: Ren Mingxin <renmx@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20110412 CentOS/3.1.3-1.el6.centos Thunderbird/3.1.3
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, Kay Sievers <kay.sievers@vrfy.org>,
        Tokunaga Kei <tokunaga.keiich@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>,
        UDEV <linux-hotplug@vger.kernel.org>
Subject: Re: [RFC PATCH] virtio_blk: Checking "private_data"  to avoid kernel
 panic when hotplugging
References: <4F728831.2090406@cn.fujitsu.com> <20120409075318.GB27771@redhat.com>
In-Reply-To: <20120409075318.GB27771@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/04/11 11:16:07,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/04/11 11:16:50,
	Serialize complete at 2012/04/11 11:16:50
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 04/09/2012 03:53 PM, Michael S. Tsirkin wrote:
> On Wed, Mar 28, 2012 at 11:40:33AM +0800, Ren Mingxin wrote:
>> On guest with upstream's kernel(3.3.0-rc7), I
>> mounted virtblk as:
>>    a) # mkfs /dev/vda
>>    b) # mount /dev/vda /mnt
>>    c) # cd /mnt
>>
>> Then I did hotplug for virtblk via virsh on host as:
>>    a) # sudo virsh detach-disk guest vda
>>    b) # sudo virsh attach-disk guest /media/data/test.img vda
>>
>> I encountered guest's kernel panic (*probability*
>> *event*)whose backtrace liked this:
> Any news here? Managed to trace?

Sorry, I had a leave last week.

> Does this still happen with 3.4-rc2?

I retested this with 3.4-rc2, but the panic couldn't be reproduced.
(Last time, It seemed that the upstream's kernel was 3.3-rc7)

> There's a chance you are hitting a race fixed by
> 4678d6f970c2f7c0cbfefc0cc666432d153b321b.
>
> If it's still not fixed it might make sense to enable slab debugging -
> we might have a use after free here.
>

I don't think the below commit has fixed this panic issue, for it is 
included
in my last test environment(3.3-rc7).
4678d6f970c2f7c0cbfefc0cc666432d153b321b

Now, I'd find which commit makes sense.

-- 
Thanks,
Ren

