Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812Ab0I3CPW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 22:15:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35519 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab0I3CPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 22:15:21 -0400
Date: Wed, 29 Sep 2010 22:15:20 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/17] fs: Clean up inode reference counting
Message-ID: <20100930021520.GA21198@infradead.org>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
 <1285762729-17928-18-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285762729-17928-18-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Besides moving this much earlier in the series as mentioned before
the most important thing is giving the helpers a different name as
the iget name is already used for a different purpose, even if
got rid of the original iget and only have iget_locked.  I think
iref/iref_locked would be good enough names for the helpers.

One other things is that a lot of the current igrab users could
use this helper instead - there's very few places where we look at
inodes that don't already have a permanent reference when we try
to acquire another one.

