Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658Ab0JHILH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 04:11:07 -0400
Received: from canuck.infradead.org ([134.117.69.58]:47373 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827Ab0JHILF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 04:11:05 -0400
Date: Fri, 8 Oct 2010 04:11:04 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/18] fs: Reduce inode I_FREEING and factor inode
 disposal
Message-ID: <20101008081104.GA2239@infradead.org>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-19-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286515292-15882-19-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> After the inode scalability work, there is not a big reason to batch
> up inodes to reclaim them, so we can dispose them as they are found
> from the LRU. With similar reasoning, we can do the same during
> unmount, completely removing the need for the dispose_list()
> function.

Given that two of the three callers already remove the inode from the
per-sb list what about doing that in the third also and stop bothering
with it in dispose_one_inode?

