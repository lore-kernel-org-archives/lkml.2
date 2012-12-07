Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424370Ab2LGB5P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 20:57:15 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:45961 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422905Ab2LGB5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 20:57:13 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmANAIZLwVB5LHa//2dsb2JhbABEDrgshXoXc4IeAQEEATocEhYLCAMYLhQlAyEBEhQHh28FwnMUjCWDYmEDlgKQSII1UoFQBw
Date: Fri, 7 Dec 2012 12:57:09 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH, 3.7-rc7, RESEND] fs: revert commit bbdd6808 to fallocate
 UAPI
Message-ID: <20121207015709.GE27172@dastard>
References: <1353366267-15629-1-git-send-email-david@fromorbit.com>
 <201212051148.28039.Martin@lichtvoll.de>
 <CA+55aFzgP29WfB1yvnj+Q9-TsbX+b-TCCjTS_vPJ16DxMy6aDQ@mail.gmail.com>
 <201212051718.44017.Martin@lichtvoll.de>
 <CA+55aFxsPBo4TZEPq+14NBE8Snmd9qiTjAiEP0fFXBzaJ9y+gw@mail.gmail.com>
 <20121206011402.GB27172@dastard>
 <20121206120645.GB14100@infradead.org>
 <20121206165024.GA30273@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121206165024.GA30273@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06, 2012 at 11:50:24AM -0500, Theodore Ts'o wrote:
> On Thu, Dec 06, 2012 at 07:06:45AM -0500, Christoph Hellwig wrote:
> > 
> > Also the only conference outcome I remember is that everyone at LSF
> > except for Ted basically said "no fucking way".
> > 
> 
> At LSF, that's correct.  And as a result, the people who need this --
> Google and Tao Bao -- have decided to keep the patch as an out-of-tree
> patch, much like the Android wakelock patch was out of tree, and for
> similar reasons --- because the community has rejected the
> functionality.

Sure. But your association argument can be shown to be a fallacy
very easily.  There was agreement that wakelock-like functionality
was needed, the problems were with the proposed implementation and
that everyone would work together on a solution. Hence the mainline
kernel now has integrated wakelock support.

Compare that to stale-no-hide: the -concept- was given a fairly
unanimous "not a chance in hell" send-off. There was no "lets rework
it into something acceptable" compromise - the concept was
rejected and so you simply cannot compare it to wakelocks.

> At this point, I've only asked that the bit be reserved, so we don't

Really? We wouldn't be having this discussion if you'd just asked...

> have to worry about codepoint collisions.  (We'd have the same issue
> with an ioctl, BTW --- we would need to reserve an ioctl number to
> avoid collisions, although granted there are ways to cleverly choose
> an ioctl number that would reduce the chance of collisions even if it
> isn't formally reserved.)

struct ext4_ioc_falloc {
...
};

/* security hole reserved for out-of-tree patches. */
#define EXT4_IOC_FALLOC_NOHIDE		_IOW('f', 10000, struct ext4_ioc_falloc)

Done. Not so hard, is it?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
