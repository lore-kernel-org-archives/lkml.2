Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab2DBBSj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 21:18:39 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58057 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753730Ab2DBBSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 21:18:36 -0400
X-IronPort-AV: E=Sophos;i="4.75,354,1330876800"; 
   d="scan'208";a="4670690"
Message-ID: <4F78FE7F.7070403@cn.fujitsu.com>
Date: Mon, 02 Apr 2012 09:18:55 +0800
From: Ren Mingxin <renmx@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20110412 CentOS/3.1.3-1.el6.centos Thunderbird/3.1.3
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Jens Axboe <axboe@kernel.dk>, "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        LKML <linux-kernel@vger.kernel.org>, SCSI <linux-scsi@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>,
        VIRTUAL <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 4/4] virtio_blk: use disk_name_format() to support mass
 of disks naming
References: <4F7581D4.4040301@cn.fujitsu.com> <4F7582B0.5010609@cn.fujitsu.com> <20120330152606.GB28934@google.com> <20120330153828.GD28934@google.com>
In-Reply-To: <20120330153828.GD28934@google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/04/02 09:18:23,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/04/02 09:18:25,
	Serialize complete at 2012/04/02 09:18:25
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 03/30/2012 11:38 PM, Tejun Heo wrote:
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
> So, if a device name ends in digit the partition code adds delimiter
> 'p' automatically and this is already in use by md.  So, partitioned
> md devices are named mdDpP where D and P are base 10 number indicating
> the sequence like md12p4.  So, let's please add comment that new
> drivers should name their devices PREFIX%d where the sequence number
> can be allocated by ida.
>
>

Oh, got it. Just like md devices' names.

-- 
Thanks,
Ren

