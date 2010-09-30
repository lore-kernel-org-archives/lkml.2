Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586Ab0I3BwQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 21:52:16 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59836 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218Ab0I3BwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 21:52:15 -0400
Date: Wed, 29 Sep 2010 21:52:14 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/17] fs: Introduce per-bucket inode hash locks
Message-ID: <20100930015213.GA1535@infradead.org>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
 <1285762729-17928-13-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285762729-17928-13-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Instead of doing the lock overkill on a still fundamentally global data
structure what about replacing this with something better.  I know
you've already done this with the XFS icache, and while the per-AG
concept obviously can't be generic at least some of the lessons could be
applied.

then again how much testing did this get anyway given that you
benchmark ran mostly XFS which doesn't hit this at all?

If it was up to me I'd dtop this (and the bl_list addition) from the
series for now and wait for people who care about the scalability of
the generic icache code to come up with a better data structure.

