Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950Ab1KUBvz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 20:51:55 -0500
Received: from gate.crashing.org ([63.228.1.57]:33268 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754772Ab1KUBvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 20:51:54 -0500
Message-ID: <1321840301.13860.9.camel@pasglop>
Subject: Re: 3.2.0-rc1 panic on PowerPC
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Christian Kujau <lists@nerdbynature.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org
Date: Mon, 21 Nov 2011 12:51:41 +1100
In-Reply-To: <1321838742.13860.8.camel@pasglop>
References: <alpine.DEB.2.01.1111150035560.8000@trent.utfs.org>
	 <alpine.DEB.2.01.1111201529070.8000@trent.utfs.org>
	 <1321837101.13860.6.camel@pasglop>
	 <alpine.DEB.2.01.1111201701000.8000@trent.utfs.org>
	 <1321838742.13860.8.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-21 at 12:25 +1100, Benjamin Herrenschmidt wrote:
> On Sun, 2011-11-20 at 17:17 -0800, Christian Kujau wrote:
> > On Mon, 21 Nov 2011 at 11:58, Benjamin Herrenschmidt wrote:
> > > I've seen something similar with 3.2-rc2 at cfcfc9ec, unfortunately I
> > > couldn't capture the oops log at the time.
> > 
> > It just happened again today, after heavy CPU & IO load (rsyncing from/to 
> > external disks on dm-crypt). This time the oops was printed on the screen 
> > but nothing on netconsole:
> > 
> > http://nerdbynature.de/bits/3.2.0-rc1/oops/oops3m.JPG
> > 
> > It looks like the oops I reported earlier (oops2m.JPG) so I doubt it's a 
> > random corruption due to hardware issues...?
> 
> Yeah it's starting to look like a pattern. Your latest oops looks a lot
> like the one I had (though it was with tg3 on the g5), ie, vfs_read ->
> driver -> allocator -> crash.
> 
> > Any debug or boot options to set in my next kernel build?
> 
> Well, you can turn everything on see whether that makes any difference
> or finds something a bit more precisely

BTW. SLUB or SLAB ? Mine was SLUB with SLUB_DEBUG enabled (tho the debug
didn't seem to catch anything).

Cheers,
Ben.


