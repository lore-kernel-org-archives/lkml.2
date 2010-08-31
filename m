Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903Ab0HaK1P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 06:27:15 -0400
Received: from daytona.panasas.com ([67.152.220.89]:34128 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752855Ab0HaK1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 06:27:13 -0400
Message-ID: <4C7CD8F8.4050409@panasas.com>
Date: Tue, 31 Aug 2010 13:27:04 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Jan Kara <jack@suse.cz>, Jeff Moyer <jmoyer@redhat.com>,
        Christoph Hellwig <hch@lst.de>, jaxboe@fusionio.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-raid@vger.kernel.org, James.Bottomley@suse.de, tytso@mit.edu,
        chris.mason@oracle.com, swhiteho@redhat.com,
        konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, vst@vlnb.net,
        rwheeler@redhat.com, hare@suse.de, neilb@suse.de,
        rusty@rustcorp.com.au, mst@redhat.com, jeremy@goop.org,
        snitzer@redhat.com, k-ueda@ct.jp.nec.com,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 26/30] ext4: do not send discards as barriers
References: <1282751267-3530-1-git-send-email-tj@kernel.org> <1282751267-3530-27-git-send-email-tj@kernel.org> <20100825155842.GA3229@lst.de> <20100825160032.GC3229@lst.de> <4C753D75.2010305@kernel.org> <20100825200223.GE2738@quack.suse.cz> <4C76250B.6060800@kernel.org> <20100827173147.GA12374@quack.suse.cz> <x4939tv98n8.fsf@segfault.boston.devel.redhat.com> <20100830202034.GB12226@quack.quadriga.com> <4C7CB936.8010509@kernel.org> <4C7CD47B.1050409@panasas.com> <4C7CD5D0.40007@kernel.org>
In-Reply-To: <4C7CD5D0.40007@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Aug 2010 10:27:12.0366 (UTC) FILETIME=[1308D8E0:01CB48F7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2010 01:13 PM, Tejun Heo wrote:
> Hello,
> 
> On 08/31/2010 12:07 PM, Boaz Harrosh wrote:
>> I don't know all the specifics of the virtio driver and the KVM backend but
>> don't the KVM target io is eventually directed to a local file or device?
>> If so the scsi device has disappeard but the bulk of the data is in host cache
>> at the backstore (file or bdev). Once all files are closed the data is synced
>> to disk.
>>
>> Is it not the same as Ric's problem of disconnecting the sata cable but
>> not dropping power to the drive. The main of the cache is still intact.
> 
> There are two layers of caching there.
> 
>  drive cache - host page cache - guest
> 
> When guest issues FLUSH, qemu will translate it into fdatasync which
> will flush the host page cache followed by FLUSH to the drive which
> will flush the drive cache to the media.  If you delete the host disk
> device, it will be detached w/o host page cache flushed.  So, although
> it's not complete, it will lose good part of cache.  With out write
> out timeout increased and/or with laptop mode enabled, it will
> probably lose most of cache.
> 

Ha, ok you meant that device. So if you have a dedicated physical device
for backstore that would be a very nice scriptable way.

Thanks, that's a much better automated test than pulling drives out of
sockets.

> Thanks.
> 

Boaz
