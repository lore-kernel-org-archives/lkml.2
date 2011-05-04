Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419Ab1EDN0K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 09:26:10 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:41809 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753142Ab1EDN0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 09:26:08 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAClRwU15LBza/2dsb2JhbACmFnjFNQ6FeQSeAQ
Date: Wed, 4 May 2011 23:25:52 +1000
From: Dave Chinner <david@fromorbit.com>
To: linux-kernel@vger.kernel.org, Markus Trippelsdorf <markus@trippelsdorf.de>,
        Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>,
        xfs-masters@oss.sgi.com, xfs@oss.sgi.com,
        Christoph Hellwig <hch@infradead.org>, Alex Elder <aelder@sgi.com>,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: 2.6.39-rc3, 2.6.39-rc4: XFS lockup - regression since 2.6.38
Message-ID: <20110504132552.GG9114@dastard>
References: <20110423224403.5fd1136a@neptune.home>
 <20110427050850.GG12436@dastard>
 <20110427182622.05a068a2@neptune.home>
 <20110428194528.GA1627@x4.trippels.de>
 <20110429011929.GA13542@dastard>
 <20110504005736.GA2958@cucamonga.audible.transient.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110504005736.GA2958@cucamonga.audible.transient.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 04, 2011 at 12:57:36AM +0000, Jamie Heilman wrote:
> Dave Chinner wrote:
> > OK, so the common elements here appears to be root filesystems
> > with small log sizes, which means they are tail pushing all the
> > time metadata operations are in progress. Definitely seems like a
> > race in the AIL workqueue trigger mechanism. I'll see if I can
> > reproduce this and cook up a patch to fix it.
> 
> Is there value in continuing to post sysrq-w, sysrq-l, xfs_info, and
> other assorted feedback wrt this issue?  I've had it happen twice now
> myself in the past week or so, though I have no reliable reproduction
> technique.  Just wondering if more data points will help isolate the
> cause, and if so, how to be prepared to get them.

Not really. I think I know where the problem lies, but I currently
lack a reproducer. There's also been another regression I've only
just got to the bottom of, so I haven't really had a chance to focus
properly on this one yet. Log space hangs like this have
historically been difficult to reproduce reliably....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
