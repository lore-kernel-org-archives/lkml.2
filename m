Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab0JPQai (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 12:30:38 -0400
Received: from canuck.infradead.org ([134.117.69.58]:55162 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714Ab0JPQah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 12:30:37 -0400
Date: Sat, 16 Oct 2010 12:30:35 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/18] fs: do not assign default i_ino in new_inode
Message-ID: <20101016163035.GC20086@infradead.org>
References: <1286928961-15157-1-git-send-email-david@fromorbit.com>
 <1286928961-15157-19-git-send-email-david@fromorbit.com>
 <20101016075728.GT19147@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101016075728.GT19147@amd>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 16, 2010 at 06:57:28PM +1100, Nick Piggin wrote:
> My patch for this reduces churn by just adding a new function instead.
> The last_ino allocator is really fast now, so IMO it was not worth
> the churn to go through filesystems; just let them do it.

See the last comment on this.  Allocating an inode and assigning a badly
made up ino for a handfull synthetic filesystems are very different
things.  Mixing them up in one function always was a bad idea.

