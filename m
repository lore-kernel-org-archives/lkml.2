Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758686Ab0FJIsy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 04:48:54 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:40532 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892Ab0FJIsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 04:48:52 -0400
Date: Thu, 10 Jun 2010 01:47:07 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Tao Ma <tao.ma@oracle.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH v3] ocfs2: Let ocfs2_setattr use new truncate sequence.
Message-ID: <20100610084707.GG30672@mail.oracle.com>
Mail-Followup-To: Christoph Hellwig <hch@lst.de>,
	Tao Ma <tao.ma@oracle.com>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>
References: <20100610044234.GD26335@laptop>
 <1276146485-9346-1-git-send-email-tao.ma@oracle.com>
 <20100610082711.GA2173@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100610082711.GA2173@lst.de>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090208.4C10A6EB.00DB:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 10, 2010 at 10:27:11AM +0200, Christoph Hellwig wrote:
> You just leave the duplicate inode_newsize_ok in, but still have
> one as part of inode_change_ok.  See the previous thread - we'll
> need to move inode_change_ok to under the cluster locks, both
> for the truncate and non-truncate case.

	Is your concern that the u/gid checks may be against stale ids?

> > +		truncate_setsize(inode, attr->ia_size);
> 
> But any reason this isn't done inside the
> 
>         if (size_change && attr->ia_size != inode->i_size) {
> 
> conditional above?  You'll never get size and uid/gid changes in the
> same request, so there won't be any change in behaviour.

	I think the code exists as-is so that the i_size update only
happens after the quota transfer has been approved.  Jan added the quota
bits in this location.
	I can't see a standard posix op that changes size and ids at the
same time.  I think we just add BUG_ON expressions that ensure such a
behavior, right?

Joel

-- 

 "I'm living so far beyond my income that we may almost be said
 to be living apart."
         - e e cummings

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
