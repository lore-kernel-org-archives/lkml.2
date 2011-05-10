Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275Ab1EJICl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 04:02:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36709 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754735Ab1EJICi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 04:02:38 -0400
Date: Tue, 10 May 2011 04:02:36 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 5/14] HPFS: Remove mark_inode_dirty
Message-ID: <20110510080236.GB13420@infradead.org>
References: <alpine.DEB.2.00.1105082026220.7013@artax.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1105082026220.7013@artax.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 08, 2011 at 08:43:27PM +0200, Mikulas Patocka wrote:
> Remove mark_inode_dirty
> 
> HPFS doesn't use kernel's dirty inode indicator anyway because
> writing an inode requires directory's mutex.

No new by this patch, but note that c/mtime on mmap won't work without
using it.  We tried to get away with it for that in XFS, but it broke
the semantics.  Take a look at xfstests 215 for the reproducer.

