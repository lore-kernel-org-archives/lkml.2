Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980Ab0HQQ1Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 12:27:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:53355 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757545Ab0HQQ1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 12:27:23 -0400
Message-ID: <4C6AB74E.7080909@kernel.org>
Date: Tue, 17 Aug 2010 18:22:38 +0200
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
References: <1281977523-19335-1-git-send-email-tj@kernel.org> <1281977523-19335-3-git-send-email-tj@kernel.org> <20100816183317.GA28171@lst.de> <4C6A458B.5040407@kernel.org> <20100817132327.GA3347@lst.de>
In-Reply-To: <20100817132327.GA3347@lst.de>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 17 Aug 2010 16:25:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 08/17/2010 03:23 PM, Christoph Hellwig wrote:
>> Hmmm... the underlying storage could be md/dm RAIDs in which case FUA
>> should be cheaper than FLUSH.
> 
> If someone ever wrote a virtio-blk backend that sits directly ontop
> of the Linux block layer that would be true.  Of the five known
> virtio-blk backends all operate on normal files using the Posix I/O
> APIs, or the Linux aio API (optionally in qemu) or in-kernel
> vfs_read/vfs_write (vhost-blk).

Right.

> Given how little testing lguest gets compared to qemu I really don't
> want a protocol addition for it unless it really buys us something.
> Once we're done with this barrier conversion I plan into benchmarking
> FUA and a pre-flush tag on the command for virtio in real life setups,
> and see if it actually buys us anything.

Hmmm... yeah, we can drop it.  Michael, what do you think?

Thanks.

-- 
tejun
