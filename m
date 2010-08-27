Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035Ab0H0Rcp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 13:32:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47395 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754995Ab0H0Rcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 13:32:43 -0400
Date: Fri, 27 Aug 2010 19:31:48 +0200
From: Jan Kara <jack@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        jaxboe@fusionio.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org,
        James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com,
        swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp,
        dm-devel@redhat.com, vst@vlnb.net, rwheeler@redhat.com, hare@suse.de,
        neilb@suse.de, rusty@rustcorp.com.au, mst@redhat.com, jeremy@goop.org,
        snitzer@redhat.com, k-ueda@ct.jp.nec.com,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 26/30] ext4: do not send discards as barriers
Message-ID: <20100827173147.GA12374@quack.suse.cz>
References: <1282751267-3530-1-git-send-email-tj@kernel.org>
 <1282751267-3530-27-git-send-email-tj@kernel.org>
 <20100825155842.GA3229@lst.de>
 <20100825160032.GC3229@lst.de>
 <4C753D75.2010305@kernel.org>
 <20100825200223.GE2738@quack.suse.cz>
 <4C76250B.6060800@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C76250B.6060800@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 26-08-10 10:25:47, Tejun Heo wrote:
> On 08/25/2010 10:02 PM, Jan Kara wrote:
> > On Wed 25-08-10 17:57:41, Tejun Heo wrote:
> >> On 08/25/2010 06:00 PM, Christoph Hellwig wrote:
> >>> On Wed, Aug 25, 2010 at 05:58:42PM +0200, Christoph Hellwig wrote:
> >>>> On Wed, Aug 25, 2010 at 05:47:43PM +0200, Tejun Heo wrote:
> >>>>> From: Christoph Hellwig <hch@infradead.org>
> >>>>>
> >>>>> ext4 already uses synchronous discards, no need to add I/O barriers.
> >>>>
> >>>> This needs the patch that Jan sent in reply to my initial version merged
> >>>> into it.
> >>>
> >>> Actually the jbd2 patch needs it merged, but the point still stands.
> >>
> >> Yeah, wasn't sure about that one.  Has anyone tested it?  I'll be
> >> happy to merge it but I have no idea whether it's correct or not and
> >> Jan didn't seem to have tested it so...  Jan, shall I merge the patch?
> >   I'm quite confident the patch is correct so you can merge it I think but
> > tomorrow I'll give it some crash testing together with the rest of your
> > patch set in KVM to be sure.
> 
> Patch included in the series before jbd2 conversion patch.
  An update: I've set up an ext4 barrier testing in KVM - run fsstress,
kill KVM at some random moment and check that the filesystem is consistent
(kvm is run in cache=writeback mode to simulate disk cache). About 70 runs
without journal_async_commit passed fine, now I'm running some tests with
the option enabled and the first few rounds passed OK as well.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
