Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab2DBBSu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 21:18:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54564 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753730Ab2DBBSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 21:18:48 -0400
X-IronPort-AV: E=Sophos;i="4.75,354,1330876800"; 
   d="scan'208";a="4670691"
Message-ID: <4F78FE89.2070707@cn.fujitsu.com>
Date: Mon, 02 Apr 2012 09:19:05 +0800
From: Ren Mingxin <renmx@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20110412 CentOS/3.1.3-1.el6.centos Thunderbird/3.1.3
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
CC: LKML <linux-kernel@vger.kernel.org>, SCSI <linux-scsi@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>,
        VIRTUAL <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 4/4] virtio_blk: use disk_name_format() to support mass
 of disks naming
References: <4F7581D4.4040301@cn.fujitsu.com> <4F7582B0.5010609@cn.fujitsu.com> <20120330152606.GB28934@google.com> <20120330152808.GC28934@google.com>
In-Reply-To: <20120330152808.GC28934@google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/04/02 09:18:32,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/04/02 09:18:37,
	Serialize complete at 2012/04/02 09:18:37
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 03/30/2012 11:28 PM, Tejun Heo wrote:
> On Fri, Mar 30, 2012 at 08:26:06AM -0700, Tejun Heo wrote:
>> On Fri, Mar 30, 2012 at 05:53:52PM +0800, Ren Mingxin wrote:
>>>   The current virtblk's naming algorithm only supports 263  disks.
>>> If there are mass of virtblks(exceeding 263), there will be disks
>>> with the same name.
>>>
>>> By renaming "sd_format_disk_name()" to "disk_name_format()"
>>> and moving it into block core, virtio_blk can use this function to
>>> support mass of disks.
>>>
>>> Signed-off-by: Ren Mingxin<renmx@cn.fujitsu.com>
>> I guess it's already way too late but why couldn't they have been
>> named vdD-P where both D and P are integers denoting disk number and
>> partition number?  [sh]dX's were created when there weren't supposed
>> to be too many disks, so we had to come up with the horrible alphabet
>> based numbering scheme but vd is new enough.  I mean, naming is one
>> thing but who wants to figure out which sequence is or guess what
>> comes next vdzz9?  :(
>>
>> If we're gonna move it to block layer, let's add big blinking red
>> comment saying "don't ever use it for any new driver".
> And also let's make that clear in the function name - say,
> format_legacy_disk_name() or something.

So, to legacy disks [sh]d, we'd name them as [sh]d[a-z]{1,}. To new devices
like vd, we'd name them as vd<index>(vd<index>p<partno> as partitions)?
And how about the rssd in the patch 3 then?

Besides, does anybody have comments?
Looking forward to your replies ;-)

-- 
Thanks,
Ren

