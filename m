Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098Ab2DKJJW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 05:09:22 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59851 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751844Ab2DKJJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 05:09:20 -0400
X-IronPort-AV: E=Sophos;i="4.75,405,1330876800"; 
   d="scan'208";a="4730184"
Message-ID: <4F854A60.7010704@cn.fujitsu.com>
Date: Wed, 11 Apr 2012 17:09:52 +0800
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
References: <4F728831.2090406@cn.fujitsu.com> <20120409075318.GB27771@redhat.com> <4F84F7BC.102@cn.fujitsu.com> <20120411083608.GC8562@redhat.com>
In-Reply-To: <20120411083608.GC8562@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/04/11 17:08:41,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/04/11 17:08:43,
	Serialize complete at 2012/04/11 17:08:43
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 04/11/2012 04:36 PM, Michael S. Tsirkin wrote:
> On Wed, Apr 11, 2012 at 11:17:16AM +0800, Ren Mingxin wrote:
>>   On 04/09/2012 03:53 PM, Michael S. Tsirkin wrote:
>>
>>> There's a chance you are hitting a race fixed by
>>> 4678d6f970c2f7c0cbfefc0cc666432d153b321b.
>>>
>>> If it's still not fixed it might make sense to enable slab debugging -
>>> we might have a use after free here.
>>>
>> I don't think the below commit has fixed this panic issue, for it is
>> included
>> in my last test environment(3.3-rc7).
>> 4678d6f970c2f7c0cbfefc0cc666432d153b321b
>>
>> Now, I'd find which commit makes sense.
> Great, thanks very much. I do suggest slab debugging if
> the race reproduces for you with it enabled - reducing
> the chance random struct rearrangements hide the bug.
>

Much appreciated for suggesting :-)
I'll try it to locate the commit and backport it into rhel.

-- 
Thanks,
Ren

