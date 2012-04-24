Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578Ab2DXPQp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 11:16:45 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:29840 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217Ab2DXPQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 11:16:44 -0400
Date: Tue, 24 Apr 2012 11:11:25 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Martin Peres <martin.peres@labri.fr>, Ben Skeggs <bskeggs@redhat.com>,
        dri-devel@lists.freedesktop.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.4-rc4
Message-ID: <20120424151125.GA3213@phenom.dumpdata.com>
References: <CA+55aFzQD4UyPVDQesrWq7JkM=BoQevdJpQt1YyaG10MtfM-Pw@mail.gmail.com>
 <20120422040715.GA30689@elliptictech.com>
 <CA+55aFwGrb_sOjHFWe6tYwf8mmNsFbqKAhz=bq2ofiU+F+wVvA@mail.gmail.com>
 <20120422164023.GA32342@elliptictech.com>
 <20120423000554.GA893@elliptictech.com>
 <20120423024558.GD13840@phenom.dumpdata.com>
 <20120424010345.GA30674@elliptictech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120424010345.GA30674@elliptictech.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 09:03:45PM -0400, Nick Bowler wrote:
> On 2012-04-22 22:45 -0400, Konrad Rzeszutek Wilk wrote:
> > On Sun, Apr 22, 2012 at 08:05:54PM -0400, Nick Bowler wrote:
> > > Following up on the above, the commit which introduces the panics during
> > > boot is this one:
> > >
> > > commit 8e7e70522d760c4ccd4cd370ebfa0ba69e006c6e
> > > Author: Jerome Glisse <jglisse@redhat.com>
> > > Date:   Wed Nov 9 17:15:26 2011 -0500
> > > 
> > >     drm/ttm: isolate dma data from ttm_tt V4
> > 
> > I think
> > 
> > dea7e0a ttm: fix agp since ttm tt rework
> > 
> > fixed that.
> 
> Yes, I just tested this commit and the one immediately before it.  The
> one before crashes in the usual way, and dea7e0a boots (with the VGA
> output black as in the original report).  So this fixed the crash.
> 
> Now, returning to the original bisection, I marked that commit as "bad"
> and dropped all the earlier "skip" markings.  Git asks me to test commit
> 2a44e4997c5f ("drm/nouveau/disp: introduce proper init/fini, separate
> from create/destroy").  I cherry picked the aforementioned ttm fix:
> 
>   git cherry-pick -n dea7e0a
> 
> which succeeded.  Howevew, the resulting kernel still crashes early,
> although now in a different way.  I just can't win :(

Perhaps there is a better way. You could do this:

git log --oneline -r v3.2..v3.3 drivers/gpu/drm/nouveau

to get an idea of the set of patches that went in. And use that, so

git bisect start -- drivers/gpu/drm/nouveau [this should only do the bisection on those patches]

git bisect good v3.2
git bisect bad v3.3

And keep in mind the dea7e0a might need to be stuck on some of these.

This _should_ limit the bisection to just the nouveau changes, I hope.
