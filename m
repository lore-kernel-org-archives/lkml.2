Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234Ab1G0VIe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:08:34 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:52512
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753875Ab1G0VIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:08:31 -0400
Date: Wed, 27 Jul 2011 17:08:28 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dan Ehrenberg <dehrenberg@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] dio: Fast-path for page-aligned IOs
Message-ID: <20110727210828.GB12714@infradead.org>
References: <1308611855-18096-1-git-send-email-dehrenberg@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308611855-18096-1-git-send-email-dehrenberg@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 04:17:35PM -0700, Dan Ehrenberg wrote:
> The fast path does not apply for operations of the wrong size
> or alignmnent, or for operations on raw drives with 512-byte sectors.
> It might be possible to make this special case a little more general
> while maintaining its performance benefits, but I do not believe that
> the full performance benefits can be achieved without resorting to
> special handling of simple cases, as is done in this patch.

Did you check how this compares to Andis small optimizations?

Also operations on raw disks are something people with fast devices
care about a lot.  We often hear about benchmark regressions due to
stupid little things in the direct I/O code.

If we want to special case something that would be a very easy target,
with a 1:1 mapping of logical to physical blocks and thus no need
to call the allocator first, and no need for any kind of locking
or alignment handling.

