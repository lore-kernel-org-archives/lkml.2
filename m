Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614Ab1ANVNU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 16:13:20 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:39066 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab1ANVNS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 16:13:18 -0500
MIME-Version: 1.0
Message-ID: <7aa3a707-4713-41ca-b9f1-327485774722@default>
Date: Fri, 14 Jan 2011 13:11:02 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: "Ted Ts'o" <tytso@mit.edu>, Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Christoph Hellwig <hch@infradead.org>, Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: RE: clearcache (Was: Re: [git pull] vfs pile 1)
References: <20110113053554.GQ19804@ZenIV.linux.org.uk>
 <20110113172557.c016ec51.sfr@canb.auug.org.au>
 <20110113085547.GA7414@infradead.org>
 <20110113214239.1b23b523.sfr@canb.auug.org.au
 20110113220039.GF31800@thunk.org>
In-Reply-To: <20110113220039.GF31800@thunk.org>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6539.5000]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ted --

Thanks for taking the time to reply.

> The real problem is I don't think anyone is really paying attention to
> cleancache.

It's a bit more complicated than that.  There ARE a lot of people
interested in it, but there is a bit of a deadlock.  I've heard from
many people that would love to use Xen transcendent memory as
a great solution for memory overcommitment in the cloud, but they
get skittish when I tell them it requires kernel changes that haven't
been accepted upstream.  But key Linux maintainers don't consider
the Xen base interesting enough to allow merging of cleancache
(and frontswap), despite its simplicity and negligible impact,
without at least a second (and preferably in-kernel) user.

> Dan, something that might be useful to drive interest would be a
> demonstration of this improves performance on, say, a netbook using
> cleancache and zram, and how it is better than just using zram
> directly as a swap device.  With maybe some numbers?  That might get
> some interest from the community desktop distributions...

Indeed.  I was hoping that Nitin's work on zcache (the page cache
version of zram) would serve that purpose but GregKH declined to
merge it because it was dependent on unmerged cleancache... thus a
chicken-and-egg problem; and Nitin has apparently now moved on to
other (non-Linux-kernel) things.  As a result, I've spent most of my
free time over the last three months working on kztmem, which will
hopefully serve the purpose.  (I had hoped to post V1 of kztmem
by today but ran into a problem in an overnight test run.  So
stay tuned.)

Dan

P.S. The numbers look pretty good.
P.P.S. kztmem should also be easily adaptable to KVM, but I haven't
 the KVM expertise to make it happen
