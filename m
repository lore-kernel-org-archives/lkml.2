Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749Ab0JUMrr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 08:47:47 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52397 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465Ab0JUMrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 08:47:46 -0400
Date: Thu, 21 Oct 2010 08:47:43 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        Evgeniy Dushistov <dushistov@mail.ru>
Subject: Re: Remaining BKL users, what to do
Message-ID: <20101021124743.GC17654@infradead.org>
References: <201009161632.59210.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009161632.59210.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 16, 2010 at 04:32:59PM +0200, Arnd Bergmann wrote:
> fs/freevxfs:
> 	Uses the BKL in readdir and lookup, should be easy to fix. Christoph?

Can simply be dropped.  Ditto for ->put_super and the not yet done
->get_sb pushdown.  It's a trivial read-only filesystem with no state
of it's own.

> 
> fs/hpfs:
> 	Looks fixable, if anyone cares. Maybe it's time for retirement in
> 	drivers/staging though. The web page only has a Link to the
> 	linux-2.2 version.

Di you ping Mikulas?  He's not done too lately but at least ACKed a few
patches.

> fs/ncpfs:
> 	Should be fixable if Petr still cares about it. Otherwise suggest
> 	moving to drivers/staging if there are no users left.

Didn't he fix it recently?

> fs/qnx4:
> 	Should be easy to fix, there are only a few places in the code that
> 	use the BKL. Anders?

Another trivial read-only fs.  Can be trivially dropped.

> fs/ufs:
> 	Evgeniy Dushistov is maintaining this, I hope he can take care of
> 	getting rid of the BKL in UFS.

Did you ping him.  Shouldn't be too hard despite your probably unfixable
comment that somehow made it to linux-next.

