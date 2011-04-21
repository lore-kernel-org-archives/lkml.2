Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969Ab1DUTOl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 15:14:41 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:32630 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829Ab1DUTOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 15:14:40 -0400
X-IronPort-AV: E=Sophos;i="4.64,252,1301889600"; 
   d="scan'208";a="145861207"
Subject: Re: [Xen-devel] Re: [PATCH] xen block backend driver.
From: Daniel Stodden <daniel.stodden@citrix.com>
To: Christoph Hellwig <hch@infradead.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "jaxboe@fusionio.com" <jaxboe@fusionio.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad@kernel.org" <konrad@kernel.org>
In-Reply-To: <20110421190606.GA10793@infradead.org>
References: <1303333543-5915-1-git-send-email-konrad.wilk@oracle.com>
	 <1303333543-5915-2-git-send-email-konrad.wilk@oracle.com>
	 <20110421034016.GB11501@infradead.org>
	 <1303412592.9571.126.camel@agari.van.xensource.com>
	 <20110421190606.GA10793@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Apr 2011 12:14:37 -0700
Message-ID: <1303413277.9571.133.camel@agari.van.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-21 at 15:06 -0400, Christoph Hellwig wrote:
> On Thu, Apr 21, 2011 at 12:03:12PM -0700, Daniel Stodden wrote:
> > Yes, everybody is aware that the semantics were broken. But note it's
> > not even a consistency issue at this point, because there's currently no
> > frontend which relies on the original ordering semantics either. Take
> > xen-blkfront, since blk_flush it uses the barrier op for a flush, being
> > just a superset when ordering is enforced.
> 
> There is a huge userbase of guests out there that does rely on it.

Which ones? Old blkfront would have make a difference back then when
barriers used to be an option, but it never actually declared it, right?

> > But before we just enumerate a new command, a potentially more viable
> > option would be FLUSH+FUA flags on the WRITE operation. As if mapping
> > bio bits.
> > 
> > The advantage is that it avoids the extra round trip implied by having
> > the frontend driving writes through FSEQ_PREFLUSH on their own. I'd
> > expect that to make much more of a performance difference. Somewhat
> > differentiating PV from the low physical layer.
> > 
> > Would you, maybe did you, consider that? I think it sounds interesting
> > enough to gather performance data, just asking beforehand.
> 
> You will need a pure flush anyway.  Once you actually have a correct
> implementation you can look into optimizing it.  Note that at least
> the Solaris Xen coded added a cache flush to the protocol.

Weeeeeelll, I certainly hope it can deal with backends which never got
to see those headers. :o)

Daniel


