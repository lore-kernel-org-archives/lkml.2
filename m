Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138Ab1BWXrz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 18:47:55 -0500
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:36131 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751173Ab1BWXrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 18:47:53 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAK8oZU15LFEb/2dsb2JhbACmHnS8JA2FUQQ
Date: Thu, 24 Feb 2011 10:47:50 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, Andreas Dilger <adilger@dilger.ca>,
        Jens Axboe <axboe@kernel.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Mingming Cao <mcao@us.ibm.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [RFC] block integrity: Fix write after checksum calculation
 problem
Message-ID: <20110223234750.GM3166@dastard>
References: <20110222020022.GH32261@tux1.beaverton.ibm.com>
 <180713DB-114C-454B-A91E-063AB0116251@dilger.ca>
 <20110222194538.GU27190@tux1.beaverton.ibm.com>
 <20110222225351.GG3166@dastard>
 <yq1vd0awwfh.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1vd0awwfh.fsf@sermon.lab.mkp.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 11:24:50AM -0500, Martin K. Petersen wrote:
> >>>>> "Dave" == Dave Chinner <david@fromorbit.com> writes:
> 
> >> Agreed.  I too am curious to study which circumstances favor copying
> >> vs blocking.
> 
> Dave> IMO blocking is generally preferable in high throughput threaded
> Dave> workloads as there is always another thread that can do useful
> Dave> work while we wait for IO to complete. Most use cases for DIF
> Dave> center around high throughput environments....
> 
> Yeah.
> 
> A while back I did a bunch of tests with a liberal amount of
> wait_on_page_writeback() calls added to (I think) ext2, ext3, and
> XFS. For my regular workloads there was no measurable change (kernel
> builds, random database and I/O tests). I'm sure we'll unearth some apps
> that will suffer when DI is on but so far I'm not too worried about
> blocking in the data path.
> 
> My main concern is wrt. metadata because that's where extN really
> hurts. Simple test: Unpack a kernel tarball and watch the directory
> block fireworks. Given how frequently those buffers get hit I'm sure
> blocking would cause performance to tank completely. I looked into
> fixing this in ext2 but I had to stop because my eyes were bleeding.

Not problems with metadata modifications for XFS - all metadata IO
is done with a lock held preventing modifications while IO is in
progress.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
