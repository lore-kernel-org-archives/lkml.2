Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590Ab0HQIUy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 04:20:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:50531 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752829Ab0HQIUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 04:20:51 -0400
Message-ID: <4C6A458B.5040407@kernel.org>
Date: Tue, 17 Aug 2010 10:17:15 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com,
        swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp,
        dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com,
        hare@suse.de, neilb@suse.de, rusty@rustcorp.com.au, mst@redhat.com
Subject: Re: [PATCH 2/5] virtio_blk: implement REQ_FLUSH/FUA support
References: <1281977523-19335-1-git-send-email-tj@kernel.org> <1281977523-19335-3-git-send-email-tj@kernel.org> <20100816183317.GA28171@lst.de>
In-Reply-To: <20100816183317.GA28171@lst.de>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 17 Aug 2010 08:20:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 08/16/2010 08:33 PM, Christoph Hellwig wrote:
> On Mon, Aug 16, 2010 at 06:52:00PM +0200, Tejun Heo wrote:
>> From: Tejun Heo <tj@kernle.org>
>>
>> Remove now unused REQ_HARDBARRIER support and implement REQ_FLUSH/FUA
>> support instead.  A new feature flag VIRTIO_BLK_F_FUA is added to
>> indicate the support for FUA.
> 
> I'm not sure it's worth it.  The pure REQ_FLUSH path works not and is
> well tested with kvm/qemu.   We can still easily add a FUA bit, and
> even a pre-flush bit if the protocol roundtrips matter in real life
> benchmarking.

Hmmm... the underlying storage could be md/dm RAIDs in which case FUA
should be cheaper than FLUSH.

Thanks.

-- 
tejun
