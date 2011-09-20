Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410Ab1ITQam (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 12:30:42 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:38889
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750834Ab1ITQak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 12:30:40 -0400
Date: Tue, 20 Sep 2011 12:30:34 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Shawn Bohrer <sbohrer@rgmadvisors.com>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: Stalls during writeback for mmaped I/O on XFS in 3.0
Message-ID: <20110920163034.GB18914@infradead.org>
References: <20110915144755.GB2235@BohrerMBP.rgmadvisors.com>
 <20110915145556.GA19902@infradead.org>
 <20110915154748.GC2235@BohrerMBP.rgmadvisors.com>
 <20110916002557.GN11984@tux1.beaverton.ibm.com>
 <20110916163232.GA2109@BohrerMBP.rgmadvisors.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110916163232.GA2109@BohrerMBP.rgmadvisors.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 16, 2011 at 11:32:32AM -0500, Shawn Bohrer wrote:
> So for the most part it sounds like this change is needed for DIF/DIX.
> Could we only enable the wait_on_page_writeback() if
> CONFIG_BLK_DEV_INTEGRITY is set?  Does it make sense to tie these
> together?

It will also allow for huge efficiency gains on software raid.  There
have been some Lustre patches for that.

> The other thread in this case is the [flush-8:0] daemon writing back
> the pages.  So in our case you could see the spikes every time it wakes
> up to write back dirty pages.  While we can control this to some
> extent with vm.dirty_writeback_centisecs and vm.dirty_expire_centisecs
> it essentially impossible to ensure the writeback doesn't coincide
> with us writing to the page again.

Can you explain how your use case looks in more details?  Right now
for example a mlock removes the page from the lru list and thus stops
VM writeback.  If such an interface would be useful for you we could
offer an fadvice call that stops writeback entirely, and requires you
to force it when you want it.
