Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933447Ab0JSFlD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 01:41:03 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56942 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501Ab0JSFlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 01:41:01 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Nick Piggin <npiggin@kernel.dk>
Subject: Re: [patch 03/35] mm: implement per-zone shrinker
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20101019053320.GA7470@amd>
References: <20101019134345.A1E9.A69D9226@jp.fujitsu.com> <20101019053320.GA7470@amd>
Message-Id: <20101019143806.A1F5.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 19 Oct 2010 14:40:55 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi,
> 
> On Tue, Oct 19, 2010 at 01:49:12PM +0900, KOSAKI Motohiro wrote:
> > Hi
> > 
> > > Index: linux-2.6/include/linux/mm.h
> > > ===================================================================
> > > --- linux-2.6.orig/include/linux/mm.h	2010-10-19 14:19:40.000000000 +1100
> > > +++ linux-2.6/include/linux/mm.h	2010-10-19 14:36:48.000000000 +1100
> > > @@ -997,6 +997,10 @@
> > >  /*
> > >   * A callback you can register to apply pressure to ageable caches.
> > >   *
> > > + * 'shrink_zone' is the new shrinker API. It is to be used in preference
> > > + * to 'shrink'. One must point to a shrinker function, the other must
> > > + * be NULL. See 'shrink_slab' for details about the shrink_zone API.
> > 
> ...
> 
> > Now we decided to don't remove old (*shrink)() interface and zone unaware
> > slab users continue to use it. so why do we need global argument?
> > If only zone aware shrinker user (*shrink_zone)(), we can remove it.
> > 
> > Personally I think we should remove it because a removing makes a clear
> > message that all shrinker need to implement zone awareness eventually.
> 
> I agree, I do want to remove the old API, but it's easier to merge if
> I just start by adding the new API. It is split out from my previous
> patch which does convert all users of the API. When this gets merged, I
> will break those out and send them via respective maintainers, then
> remove the old API when they're all converted upstream.

Ok, I've got. I have no objection this step-by-step development. thanks
quick responce!




