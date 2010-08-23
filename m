Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897Ab0HWOUE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 10:20:04 -0400
Received: from verein.lst.de ([213.95.11.210]:58719 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752827Ab0HWOUB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 10:20:01 -0400
Date: Mon, 23 Aug 2010 16:19:35 +0200
From: Christoph Hellwig <hch@lst.de>
To: Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <jaxboe@fusionio.com>,
        Ric Wheeler <rwheeler@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "James.Bottomley@suse.de" <James.Bottomley@suse.de>,
        "tytso@mit.edu" <tytso@mit.edu>,
        "chris.mason@oracle.com" <chris.mason@oracle.com>,
        "swhiteho@redhat.com" <swhiteho@redhat.com>,
        "konishi.ryusuke@lab.ntt.co.jp" <konishi.ryusuke@lab.ntt.co.jp>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "vst@vlnb.net" <vst@vlnb.net>, "jack@suse.cz" <jack@suse.cz>,
        "hare@suse.de" <hare@suse.de>
Subject: Re: [PATCHSET block#for-2.6.36-post] block: replace barrier with sequenced flush
Message-ID: <20100823141935.GA23963@lst.de>
References: <1281616891-5691-1-git-send-email-tj@kernel.org> <20100820132214.GA6184@lst.de> <4C6E9CAF.5010202@redhat.com> <4C7269E9.9070304@kernel.org> <20100823124815.GA20095@lst.de> <4C727E96.5020801@redhat.com> <4C727F2B.6060501@fusionio.com> <20100823140823.GA23490@lst.de> <4C728210.6040605@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C728210.6040605@kernel.org>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 04:13:36PM +0200, Tejun Heo wrote:
> Yeah, that sounds reasonable.  blk_queue_flush() can be called anytime
> without locking anyway, so it should be really easy to implement too.

I don't think we can simply call blk_queue_flush - we must ensure to
never set more bits than the device allows.  We'll just need two
sets of flags in the request queue, with the sysfs file checking that
it never allows more flags than blk_queue_flush.

I'll prepare a patch for this on top of the current series.

