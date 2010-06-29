Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202Ab0F2IRK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 04:17:10 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:50261 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924Ab0F2IRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 04:17:07 -0400
Date: Tue, 29 Jun 2010 01:16:11 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com,
       Tao Ma <tao.ma@oracle.com>, Dave Chinner <dchinner@redhat.com>,
       Christoph Hellwig <hch@lst.de>, Mark Fasheh <mfasheh@suse.com>
Subject: Re: [Ocfs2-devel] [PATCH] Revert "writeback: limit
 write_cache_pages integrity scanning to current EOF"
Message-ID: <20100629081611.GB4150@mail.oracle.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Dave Chinner <david@fromorbit.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	ocfs2-devel@oss.oracle.com, Tao Ma <tao.ma@oracle.com>,
	Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
	Mark Fasheh <mfasheh@suse.com>
References: <20100628173529.GA10573@mail.oracle.com>
 <20100629002421.GY6590@dastard>
 <20100629005403.GC24343@mail.oracle.com>
 <AANLkTil1R9I94pVXLE50JAMPIwpiaZuroJAg4wcwyBUb@mail.gmail.com>
 <20100629015822.GD24343@mail.oracle.com>
 <AANLkTil5y7F9w-18mVi0G1S5pSv9MiKq6XL5MWAMFBQM@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTil5y7F9w-18mVi0G1S5pSv9MiKq6XL5MWAMFBQM@mail.gmail.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4C29ABDD.01EC:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 28, 2010 at 07:20:33PM -0700, Linus Torvalds wrote:
> I dunno. Filesystem corruption makes me nervous. So I'm certainly
> totally willing to do the revert if that makes ocfs2 work again. Even
> if "work again" happens to be partly by mistake, and for some reason
> that isn't obvious.

	Filesystem corruption makes me more than nervous.  I'm quite
devastated by this.

> Your call, I guess.  If any ocfs2 fix looks scary, and you'd prefer to
> have an -rc4 (in a few days - not today) with just the revert, I'm ok
> with that. Even if it's only a "at least no worse than 2.6.34"
> situation rather than a real fix.

	I've checked both before this patch and with the patch reverted.
We corrupt in both cases.  The problem is our assumption about zeroing
past i_size.  The revert will fix our BUG_ON, but not the corruption.
	Mark and I have ideas on how to fix the actual bug, but they
will take some time and especially testing.  We also have some
shorter-term ideas on how to paper over the issue.  We have to have to
have this fixed by .35.
	If -rc4 isn't coming for a couple of days, can we hold off on
the decision until we get a chance to think about a paper-over solution
for it?  Then we can avoid the revert.

Joel

-- 

You can use a screwdriver to screw in screws or to clean your ears,
however, the latter needs real skill, determination and a lack of fear
of injuring yourself.  It is much the same with JavaScript.
	- Chris Heilmann

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
