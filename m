Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867Ab0F2CG4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 22:06:56 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:30004 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279Ab0F2CGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 22:06:54 -0400
Date: Mon, 28 Jun 2010 19:04:20 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com,
       Tao Ma <tao.ma@oracle.com>, Dave Chinner <dchinner@redhat.com>,
       Christoph Hellwig <hch@lst.de>, Mark Fasheh <mfasheh@suse.com>
Subject: Re: [PATCH] Revert "writeback: limit write_cache_pages integrity
 scanning to current EOF"
Message-ID: <20100629020420.GE24343@mail.oracle.com>
Mail-Followup-To: Dave Chinner <david@fromorbit.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	ocfs2-devel@oss.oracle.com, Tao Ma <tao.ma@oracle.com>,
	Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
	Mark Fasheh <mfasheh@suse.com>
References: <20100628173529.GA10573@mail.oracle.com>
 <20100629002421.GY6590@dastard>
 <20100629005403.GC24343@mail.oracle.com>
 <20100629015615.GZ6590@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100629015615.GZ6590@dastard>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4C295500.01E5:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 11:56:15AM +1000, Dave Chinner wrote:
> > 	Regarding XFS, how do you handle catching the tail of an
> > allocation with an lseek(2)'d write?  That is, your current allocation
> > has a few blocks outside of i_size, then I lseek(2) a gigabyte past EOF
> > and write there.  The code has to recognize to zero around old_i_size
> > before moving out to new_i_size, right?  I think that's where our old
> > approaches had problems.
> 
> xfs_file_aio_write() handles both those cases for us via
> xfs_zero_eof().  What it does is map the region from the old EOF to
> the start of the new write and zeroes any allocated blocks that are
> not marked unwritten that lie within the range. It does this via the
> internal mapping interface because we hide allocated blocks past EOF
> from the page cache and higher layers.

	Makes sense as an approach.  We deliberately do this through the
page cache to take advantage of its I/O patterns and tie in with JBD2.
Also, we don't feel like maintaining an entire shadow page cache ;-)

Joel

-- 

Life's Little Instruction Book #356

	"Be there when people need you."

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
