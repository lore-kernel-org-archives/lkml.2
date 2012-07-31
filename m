Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099Ab2GaVNz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 17:13:55 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:45418 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069Ab2GaVNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 17:13:54 -0400
Date: Tue, 31 Jul 2012 17:04:38 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] zcache/ramster rewrite and promotion
Message-ID: <20120731210438.GA31713@phenom.dumpdata.com>
References: <c31aaed4-9d50-4cdf-b794-367fc5850483@default>
 <CAOJsxLEhW=b3En737d5751xufW2BLehPc2ZGGG1NEtRVSo3=jg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOJsxLEhW=b3En737d5751xufW2BLehPc2ZGGG1NEtRVSo3=jg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 11:53:57PM +0300, Pekka Enberg wrote:
> On Tue, Jul 31, 2012 at 11:18 PM, Dan Magenheimer
> <dan.magenheimer@oracle.com> wrote:
> > diffstat vs 3.5:
> >  drivers/staging/ramster/Kconfig       |    2
> >  drivers/staging/ramster/Makefile      |    2
> >  drivers/staging/zcache/Kconfig        |    2
> >  drivers/staging/zcache/Makefile       |    2
> >  mm/Kconfig                            |    2
> >  mm/Makefile                           |    4
> >  mm/tmem/Kconfig                       |   33
> >  mm/tmem/Makefile                      |    5
> >  mm/tmem/tmem.c                        |  894 +++++++++++++
> >  mm/tmem/tmem.h                        |  259 +++
> >  mm/tmem/zbud.c                        | 1060 +++++++++++++++
> >  mm/tmem/zbud.h                        |   33
> >  mm/tmem/zcache-main.c                 | 1686 +++++++++++++++++++++++++
> >  mm/tmem/zcache.h                      |   53
> >  mm/tmem/ramster.h                     |   59
> >  mm/tmem/ramster/heartbeat.c           |  462 ++++++
> >  mm/tmem/ramster/heartbeat.h           |   87 +
> >  mm/tmem/ramster/masklog.c             |  155 ++
> >  mm/tmem/ramster/masklog.h             |  220 +++
> >  mm/tmem/ramster/nodemanager.c         |  995 +++++++++++++++
> >  mm/tmem/ramster/nodemanager.h         |   88 +
> >  mm/tmem/ramster/r2net.c               |  414 ++++++
> >  mm/tmem/ramster/ramster.c             |  985 ++++++++++++++
> >  mm/tmem/ramster/ramster.h             |  161 ++
> >  mm/tmem/ramster/ramster_nodemanager.h |   39
> >  mm/tmem/ramster/tcp.c                 | 2253 ++++++++++++++++++++++++++++++++++
> >  mm/tmem/ramster/tcp.h                 |  159 ++
> >  mm/tmem/ramster/tcp_internal.h        |  248 +++
> > 28 files changed, 10358 insertions(+), 4 deletions(-)
> 
> So it's basically this commit, right?

Yeah, one big RFC patch.
> 
> https://oss.oracle.com/git/djm/tmem.git/?p=djm/tmem.git;a=commitdiff;h=22844fe3f52d912247212408294be330a867937c
> 
> Why on earth would you want to move that under the mm directory?

If you take aside that problem that it is one big patch instead
of being split up in more reasonable pieces - would you recommend
that it reside in a different directory?

Or is that it does not make sense b/c it has other components in it - such
as tcp/nodemaneger/hearbeat/etc so it should go under the refactor knife?

And if you rip out the ramster from this and just concentrate on zcache -
should that go in drivers/mm or mm/tmem/zcache?

> 
>                         Pekka
