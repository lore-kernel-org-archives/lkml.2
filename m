Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637Ab0HPSd6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 14:33:58 -0400
Received: from verein.lst.de ([213.95.11.210]:54238 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755462Ab0HPSd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 14:33:56 -0400
Date: Mon, 16 Aug 2010 20:33:17 +0200
From: Christoph Hellwig <hch@lst.de>
To: Tejun Heo <tj@kernel.org>
Cc: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de,
        James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com,
        swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp,
        dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com,
        hare@suse.de, neilb@suse.de, rusty@rustcorp.com.au, mst@redhat.com,
        Tejun Heo <tj@kernle.org>
Subject: Re: [PATCH 2/5] virtio_blk: implement REQ_FLUSH/FUA support
Message-ID: <20100816183317.GA28171@lst.de>
References: <1281977523-19335-1-git-send-email-tj@kernel.org> <1281977523-19335-3-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281977523-19335-3-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 16, 2010 at 06:52:00PM +0200, Tejun Heo wrote:
> From: Tejun Heo <tj@kernle.org>
> 
> Remove now unused REQ_HARDBARRIER support and implement REQ_FLUSH/FUA
> support instead.  A new feature flag VIRTIO_BLK_F_FUA is added to
> indicate the support for FUA.

I'm not sure it's worth it.  The pure REQ_FLUSH path works not and is
well tested with kvm/qemu.   We can still easily add a FUA bit, and
even a pre-flush bit if the protocol roundtrips matter in real life
benchmarking.

