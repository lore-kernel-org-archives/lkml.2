Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792Ab2AYWzj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 17:55:39 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:19600 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750832Ab2AYWzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 17:55:38 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av8EAKKHIE95LElR/2dsb2JhbABChQmpO4EGgXIBAQUjDwEjIxAIAQIYAgImAgIUJQMhE64+kVUTgRyHYAEGBgkFBAMHAhAGBQcFg1kBBQQFEAaCH4EWBJUdkmY
Date: Thu, 26 Jan 2012 09:55:35 +1100
From: Dave Chinner <david@fromorbit.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Amit Sahrawat <amit.sahrawat83@gmail.com>, xfs@oss.sgi.com,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: Does Ext4 support parallel write similar to XFS?
Message-ID: <20120125225535.GU15102@dastard>
References: <CADDb1s2w9ZwMXn38n8TcxhFNrUsXN1Gnxq-suAP2-M+R7YhFsg@mail.gmail.com>
 <4F202F2E.9000608@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4F202F2E.9000608@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 10:34:54AM -0600, Eric Sandeen wrote:
> On 1/24/12 11:19 PM, Amit Sahrawat wrote:
> > In XFS we can write parallel (i.,e we can make use of allocation
> > groups for writing process). If the files are kept in individual
> > directories, there is a possibility that first the blocks for that
> > files be used from individual allocation groups. If I start ‘4’
> > writing process(cp 100MB_file /<dirnum>/) – after writing is finished
> > – if I check the bmap – it does shows that initial allocation was from
> > individual allocation groups.
> > Even though in Ext4 also we do have groups – but I am not able to get
> > behavior similar to XFS.
> > If I check the file extents – the extents are in mixed form, the
> > allocation pattern is also very fragmented.
> > 
> > Please share more on this. Also, if there is a possible exact test
> > case to check for parallel writes support.
> 
> It seems that you are asking more about allocation policy than parallelism
> in general?  With either filesystem, you could use preallocation to wind
> up with more contiguous files when you write them in parallel, though
> that requires some idea of the file size ahead of time.
> 
> ext4 doesn't have that exact dir::group heuristic that xfs uses,
> but it does have other mechanisms and heuristics to try to get good
> file and directory layout.

XFs has different allocation policies according to mount options
used.  inode32 (default for > 1TB), inode64 (default for <1TB) and
filestreams. Each will give you different layouts for the same test
depending on the size of your filesystem and the amount of free
space you have available in it.

If XFS does what you want, then use it. There is no good reason for
trying to make ext4 do everything XFS does because it simply can't.
Especially when it comes to allocation strategies and policies...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
