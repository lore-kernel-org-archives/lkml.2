Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759952Ab2DKB1t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 21:27:49 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:46914 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755933Ab2DKB1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 21:27:48 -0400
X-IronPort-AV: E=Sophos;i="4.75,402,1330876800"; 
   d="scan'208";a="4724966"
Message-ID: <4F84DE33.8050606@cn.fujitsu.com>
Date: Wed, 11 Apr 2012 09:28:19 +0800
From: Ren Mingxin <renmx@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20110412 CentOS/3.1.3-1.el6.centos Thunderbird/3.1.3
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: mst@redhat.com, rusty@rustcorp.com.au, axboe@kernel.dk, tj@kernel.org,
        James.Bottomley@HansenPartnership.com, asamymuthupa@micron.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio_blk: Add help function to format mass of disks
References: <1334042885-8330-1-git-send-email-renmx@cn.fujitsu.com> <4F84329A.60703@redhat.com>
In-Reply-To: <4F84329A.60703@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/04/11 09:27:10,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/04/11 09:27:12,
	Serialize complete at 2012/04/11 09:27:12
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 04/10/2012 09:16 PM, Avi Kivity wrote:
> On 04/10/2012 10:28 AM, Ren Mingxin wrote:
>> The current virtio block's naming algorithm just supports 18278
>> (26^3 + 26^2 + 26) disks. If there are mass of virtio blocks,
>> there will be disks with the same name.
>>
>> Based on commit 3e1a7ff8a0a7b948f2684930166954f9e8e776fe, I add
>> function "virtblk_name_format()" for virtio block to support mass
>> of disks naming.
>>
>> Signed-off-by: Ren Mingxin<renmx@cn.fujitsu.com>
>> ---
>>   drivers/block/virtio_blk.c |   38 ++++++++++++++++++++++++++------------
>>   1 files changed, 26 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
>> index c4a60ba..86516c8 100644
>> --- a/drivers/block/virtio_blk.c
>> +++ b/drivers/block/virtio_blk.c
>> @@ -374,6 +374,31 @@ static int init_vq(struct virtio_blk *vblk)
>>   	return err;
>>   }
>>
>> +static int virtblk_name_format(char *prefix, int index, char *buf, int buflen)
>> +{
>> +	const int base = 'z' - 'a' + 1;
>> +	char *begin = buf + strlen(prefix);
>> +	char *begin = buf + strlen(prefix);
> Duplicate line.
>

Oh, obvious missed :-(

-- 
Thanks,
Ren

