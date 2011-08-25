Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742Ab1HYRA3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 13:00:29 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:20833 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593Ab1HYRA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 13:00:28 -0400
X-IronPort-AV: E=Sophos;i="4.68,281,1312156800"; 
   d="scan'208";a="7449887"
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <20054.29964.556177.999449@mariner.uk.xensource.com>
Date: Thu, 25 Aug 2011 17:15:08 +0100
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Christoph Hellwig <hch@infradead.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Jens Axboe <jaxboe@fusionio.com>,
        Greg Marsden <greg.marsden@oracle.com>, Joe Jin <joe.jin@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        Kurt C Hackel <KURT.HACKEL@oracle.com>
Subject: Re: [Xen-devel] Re: [patch] xen-blkback: sync I/O after backend
	disconnected
Newsgroups: chiark.mail.xen.devel
In-Reply-To: <m2n.s.1QsyrJ-132485@chiark.greenend.org.uk>
References: <4E48A6A6.4040706@oracle.com>
	<20110815144610.GA3707@infradead.org>
	<m2n.s.1QsyrJ-132485@chiark.greenend.org.uk>
X-Mailer: VM 8.0.9 under Emacs 21.4.1 (i486-pc-linux-gnu)
From: Ian Jackson <Ian.Jackson@eu.citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad Rzeszutek Wilk writes ("Re: [Xen-devel] Re: [patch] xen-blkback: sync I/O after backend disconnected"):
> And the guest would normally issues a FLUSH when unmounting the
> disk. Hm, I wonder what the conditions are when we forcibly kill the
> guest - there might be outstanding I/Os in the disk's cache -
> at which point we should probably sync the write cache, no?

If we forcibly kill the guest we don't care about its IO in flight.
After all we are throwing away everything that the guest has in its
queue.

Bear in mind that the reason for forcibly killing (or perhaps forcibly
detaching) might be that the underlying device has wedged somehow.  It
would be annoying if that prevented even a force detach.

Or to put it in other words: force detach and force kill should be
lossy.  Their whole point is to be the lossy version.

Ian.
