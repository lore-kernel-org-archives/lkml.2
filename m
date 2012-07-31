Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730Ab2GaKcj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 06:32:39 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:57699 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302Ab2GaKch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 06:32:37 -0400
Date: Tue, 31 Jul 2012 06:32:34 -0400 (EDT)
From: Tomas Racek <tracek@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Alex Elder <elder@kernel.org>, open list <linux-kernel@vger.kernel.org>,
        "supporter:XFS FILESYSTEM" <xfs@oss.sgi.com>,
        linux-xfs@vger.kernel.org, Ben Myers <bpm@sgi.com>,
        lczerner@redhat.com
Message-ID: <1945505398.1250534.1343730754291.JavaMail.root@redhat.com>
In-Reply-To: <20120730214946.GG2877@dastard>
Subject: Re: [PATCH 1/1] xfs: check for possible overflow in xfs_ioc_trim
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.34.27.4]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - GC20 (Linux)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +
> > +	if (range.start > ULLONG_MAX - BBSIZE)
> > +		return -XFS_ERROR(EINVAL);
> > +
> 
> There's no point checking for overflow on the range start - what we
> need to check is whether it is larger than the size of the
> filesystem. We do that after the conversion of range.start to basic
> blocks, so that check needs to be promoted to before this. i.e.
> 
> 	if (range.start >= XFS_FSB_TO_B(mp, mp->m_sb.sb_dblocks))
> 		return -XFS_ERROR(EINVAL);
> 
> >  	start = BTOBB(range.start);
> >  	end = start + BTOBBT(range.len) - 1;
> >  	minlen = BTOBB(max_t(u64, granularity, range.minlen));
> 
> And that will prevent the overflow in BTOBB() just as effectively...

You're right, that's a far better way, I'll change it so.

Thanks!

Tomas
