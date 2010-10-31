Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334Ab0JaLLL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 07:11:11 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42280 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755028Ab0JaLLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 07:11:08 -0400
Date: Sun, 31 Oct 2010 07:10:57 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "J. Bruce Fields" <bfields@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        Bryan Schumaker <bjschuma@netapp.com>, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] locks: fix leaks on setlease errors
Message-ID: <20101031111057.GA23760@infradead.org>
References: <20101030212500.GE480@fieldses.org>
 <1288474276-14288-2-git-send-email-bfields@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288474276-14288-2-git-send-email-bfields@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 30, 2010 at 05:31:14PM -0400, J. Bruce Fields wrote:
> We're depending on setlease to free the passed-in lease on failure.

But we would be much better to just free it in the caller.  I'ts much
more natural - caller allocates, caller frees, and it's also simpler.

I'll send a patch to do so shortly, together with sorting out the
remaining nfs4d lock_manager_operations abuses.  I think we're set with
that for 2.6.37, the setlease split can wait once we've sorted out the
lock freeing issue.

