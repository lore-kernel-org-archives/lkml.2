Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025Ab1DUTGL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 15:06:11 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34592 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376Ab1DUTGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 15:06:10 -0400
Date: Thu, 21 Apr 2011 15:06:06 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Daniel Stodden <daniel.stodden@citrix.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "jaxboe@fusionio.com" <jaxboe@fusionio.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad@kernel.org" <konrad@kernel.org>
Subject: Re: [Xen-devel] Re: [PATCH] xen block backend driver.
Message-ID: <20110421190606.GA10793@infradead.org>
References: <1303333543-5915-1-git-send-email-konrad.wilk@oracle.com>
 <1303333543-5915-2-git-send-email-konrad.wilk@oracle.com>
 <20110421034016.GB11501@infradead.org>
 <1303412592.9571.126.camel@agari.van.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303412592.9571.126.camel@agari.van.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 12:03:12PM -0700, Daniel Stodden wrote:
> Yes, everybody is aware that the semantics were broken. But note it's
> not even a consistency issue at this point, because there's currently no
> frontend which relies on the original ordering semantics either. Take
> xen-blkfront, since blk_flush it uses the barrier op for a flush, being
> just a superset when ordering is enforced.

There is a huge userbase of guests out there that does rely on it.

> But before we just enumerate a new command, a potentially more viable
> option would be FLUSH+FUA flags on the WRITE operation. As if mapping
> bio bits.
> 
> The advantage is that it avoids the extra round trip implied by having
> the frontend driving writes through FSEQ_PREFLUSH on their own. I'd
> expect that to make much more of a performance difference. Somewhat
> differentiating PV from the low physical layer.
> 
> Would you, maybe did you, consider that? I think it sounds interesting
> enough to gather performance data, just asking beforehand.

You will need a pure flush anyway.  Once you actually have a correct
implementation you can look into optimizing it.  Note that at least
the Solaris Xen coded added a cache flush to the protocol.

