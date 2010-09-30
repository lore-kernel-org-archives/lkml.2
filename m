Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784Ab0I3AH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 20:07:57 -0400
Received: from verein.lst.de ([213.95.11.210]:42862 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120Ab0I3AH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 20:07:56 -0400
Date: Thu, 30 Sep 2010 02:06:41 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>, Chris Mason <chris.mason@oracle.com>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Jens Axboe <jaxboe@fusionio.com>,
        linux-btrfs@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, stable@kernel.org,
        Jens Axboe <axboe@kernel.dk>, Micha?? Piotrowski <mkkp4x4@gmail.com>,
        Chuck Ebbert <cebbert@redhat.com>, kernel@lists.fedoraproject.org,
        linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>
Subject: Re: Dirtiable inode bdi default != sb bdi btrfs
Message-ID: <20100930000641.GA27865@lst.de>
References: <4C9AA546.6050201@cesarb.net> <20100923123849.8975fe47.akpm@linux-foundation.org> <20100927222548.GG3610@quack.suse.cz> <20100927225452.GG4270@think> <20100929081936.GA23322@lst.de> <20100929121808.GB3290@quack.suse.cz> <20100929141006.GB7439@lst.de> <20100929233806.GB12707@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100929233806.GB12707@quack.suse.cz>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 30, 2010 at 01:38:07AM +0200, Jan Kara wrote:
> > No.  For one thing we don't need any exception for correctnes alone -
> > even the block device variant would work fine with the default case.
> Here I don't agree. If you don't have some kind of exception, sb->s_bdi
> for both "block" and "mtd_inodefs" filesystems points to
> noop_backing_dev_info and you get no writeback for that one. So it isn't
> just a performance issue but also a correctness one.

Indeed - for internal filesystems that require writeback the change
causes trouble if they haven't registered a s_bdi.  But for all user
visible filesystems that doesn't happen as we require s_bdi for
sync or even unmounts to work.
