Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757799Ab0HQRAD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 13:00:03 -0400
Received: from verein.lst.de ([213.95.11.210]:44510 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757584Ab0HQRAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 13:00:00 -0400
Date: Tue, 17 Aug 2010 18:59:29 +0200
From: Christoph Hellwig <hch@lst.de>
To: Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, jaxboe@fusionio.com,
        linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, James.Bottomley@suse.de, tytso@mit.edu,
        chris.mason@oracle.com, swhiteho@redhat.com,
        konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, vst@vlnb.net,
        jack@suse.cz, rwheeler@redhat.com, hare@suse.de
Subject: Re: [PATCHSET block#for-2.6.36-post] block: replace barrier with sequenced flush
Message-ID: <20100817165929.GB13800@lst.de>
References: <1281616891-5691-1-git-send-email-tj@kernel.org> <20100813114858.GA31937@lst.de> <4C654D4B.1030507@kernel.org> <20100813143820.GA7931@lst.de> <4C655BE5.4070809@kernel.org> <20100814103654.GA13292@lst.de> <4C6A5D8A.4010205@kernel.org> <20100817131915.GB2963@lst.de> <4C6ABBCB.9030306@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C6ABBCB.9030306@kernel.org>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0.001 () BAYES_50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 06:41:47PM +0200, Tejun Heo wrote:
> > What other trees do you mean?
> 
> I was mostly thinking about dm/md, drdb and stuff, but you're talking
> about filesystem conversion patches being routed through block tree,
> right?

I think we really need all the conversions in one tree, block layer,
remapping drivers and filesystems.

Btw, I've done the conversion for all filesystems and I'm running tests
over them now.  Expect the series late today or tomorrow.

> I might just resequence it to finish this part of discussion but what
> does that really buy us?  It's not really gonna help bisection.
> Bisection won't be able to tell anything in higher resolution than
> "the new implementation doesn't work".  If you show me how it would
> actually help, I'll happily reshuffle the patches.

It's not bisecting to find bugs in the barrier conversion.  We can't
easily bisect it down anyway.  The problem is when we try to bisect
other problems and get into the middle of the series barriers suddenly
are gone.  Which is not very helpful for things like data integrity
problems in filesystems.

> >> I wasn't sure about that part.  You removed store_flush_error(), but
> >> DM_ENDIO_REQUEUE should still have higher priority than other
> >> failures, no?
> > 
> > Which priority?
> 
> IIUC, when any of flushes get DM_ENDIO_REQUEUE (which tells the dm
> core layer to retry the whole bio later), it trumps all other failures
> and the bio is retried later.  That was why DM_ENDIO_REQUEUE was
> prioritized over other error codes, which actually is sort of
> incorrect in that once a FLUSH fails, it _MUST_ be reported to upper
> layers as FLUSH failure implies data already lost.  So,
> DM_ENDIO_REQUEUE actually should have lower priority than other
> failures.  But, then again, the error codes still need to be
> prioritized.

I think that's something we better leave to the DM team.

