Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996Ab1BDPFL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 10:05:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098Ab1BDPFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 10:05:09 -0500
Date: Fri, 4 Feb 2011 10:04:57 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <jaxboe@fusionio.com>, Mike Snitzer <snitzer@redhat.com>,
        "tytso@mit.edu" <tytso@mit.edu>,
        "djwong@us.ibm.com" <djwong@us.ibm.com>,
        "shli@kernel.org" <shli@kernel.org>, "neilb@suse.de" <neilb@suse.de>,
        "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
        "jack@suse.cz" <jack@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kmannth@us.ibm.com" <kmannth@us.ibm.com>,
        "cmm@us.ibm.com" <cmm@us.ibm.com>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "rwheeler@redhat.com" <rwheeler@redhat.com>, "hch@lst.de" <hch@lst.de>,
        "josef@redhat.com" <josef@redhat.com>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>
Subject: Re: [PATCH v3 1/2] block: skip elevator data initialization for
 flush requests
Message-ID: <20110204150456.GD32190@redhat.com>
References: <20110201185225.GT14211@htj.dyndns.org>
 <1296600373-6906-1-git-send-email-snitzer@redhat.com>
 <20110202225549.GA28109@redhat.com>
 <4D4AAC9A.4050407@fusionio.com>
 <20110203133820.GF2570@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110203133820.GF2570@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 03, 2011 at 02:38:20PM +0100, Tejun Heo wrote:
> Hey, Jens.
> 
> On Thu, Feb 03, 2011 at 02:24:42PM +0100, Jens Axboe wrote:
> > On 2011-02-02 23:55, Mike Snitzer wrote:
> > > REQ_SORTED is not set for flush requests because they are never put on
> > > the IO scheduler.
> > 
> > That looks very wrong. REQ_SORTED gets set _when_ the request is sorted
> > into the IO scheduler. This is gross misuse, a bad hack.
> 
> The rationale behind suggesting was that it indicates to the allocator
> that the request may be sorted as how the request will be used is
> communicated using @rw_flags to the allocator.  The patch is buggy
> that the flag actually ends up on the request.  Any better idea how to
> communicate it?

Though you did not like the V1 of patch, personally I also liked just parsing
FLUSH or FUA flag in get_request().

Or how about intoducing a helper function blk_rq_should_init_elevator() 
or something like that and this function will parse FLUSH, FUA flags.

Thanks
Vivek
