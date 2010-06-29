Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab0F2HT5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 03:19:57 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:42352 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363Ab0F2HT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 03:19:56 -0400
Date: Tue, 29 Jun 2010 00:18:18 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com,
       Tao Ma <tao.ma@oracle.com>, Dave Chinner <dchinner@redhat.com>,
       Christoph Hellwig <hch@lst.de>, Mark Fasheh <mfasheh@suse.com>
Subject: Re: [PATCH] Revert "writeback: limit write_cache_pages integrity
 scanning to current EOF"
Message-ID: <20100629071817.GA4150@mail.oracle.com>
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
 <20100629020420.GE24343@mail.oracle.com>
 <20100629022757.GA6590@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100629022757.GA6590@dastard>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4C299E72.0184:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 12:27:57PM +1000, Dave Chinner wrote:
> Just to clarify any possible misunderstanding here, xfs_zero_eof()
> also does it's IO through the page cache for similar reasons.  It's
> just the mappings are found via the internal interfaces before the
> zeroing is done via the anonymous pagecache_write_begin()/
> pagecache_write_end() functions (in xfs_iozero()) rather than using
> the generic block functions.

	Mark and I discussed this some earlier this evening.  I think we
might be able to get away cheaper than does.  In
ocfs2_write_begin_nolock(), we call ocfs2_expand_nonsparse_inode() in
the case of older filesystems that don't allow sparse files.  That's
where we handle the zeroing from old_i_size to pos for those files.
	I the exact same place, we could probably just detect we're
about to cover the unzeroed allocation and get it there.  This needs
some more code eval until we're sure, and then the serious testing
happens.

Joel

-- 

"Nothing is wrong with California that a rise in the ocean level
 wouldn't cure."
        - Ross MacDonald

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
