Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427Ab1BXQnm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 11:43:42 -0500
Received: from cantor.suse.de ([195.135.220.2]:53211 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756289Ab1BXQnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 11:43:39 -0500
Date: Thu, 24 Feb 2011 17:43:35 +0100
From: Jan Kara <jack@suse.cz>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <djwong@us.ibm.com>,
        Andreas Dilger <adilger@dilger.ca>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Mingming Cao <mcao@us.ibm.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [RFC] block integrity: Fix write after checksum calculation
 problem
Message-ID: <20110224164335.GG23042@quack.suse.cz>
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

On Wed 23-02-11 11:24:50, Martin K. Petersen wrote:
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
  Ext2 is problematic yes, but ext[34] should be OK because we do
metadata copy anyway because of journalling. So for ext[34] you shouldn't
need any additional metadata protection since JBD does it for you (apart
from nojournal mode of ext4 of course).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
