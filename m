Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027Ab0LHPwN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 10:52:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753970Ab0LHPwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 10:52:12 -0500
Date: Wed, 8 Dec 2010 10:51:37 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "jmarchan@redhat.com" <jmarchan@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] Don't merge different partition's IOs
Message-ID: <20101208155137.GE31703@redhat.com>
References: <4CFCB08F.4010509@jp.fujitsu.com>
 <AANLkTimzkN9iCDY6S9Pajh+BqTouggOxs56fBdwyoxHY@mail.gmail.com>
 <4CFDDFC3.2070107@jp.fujitsu.com>
 <4CFF34E7.2030401@fusionio.com>
 <4CFF3AD6.6010904@jp.fujitsu.com>
 <4CFF3C86.2070504@fusionio.com>
 <4CFF3DA4.5060705@jp.fujitsu.com>
 <4CFF9A2C.1070401@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CFF9A2C.1070401@fusionio.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 08, 2010 at 10:46:04PM +0800, Jens Axboe wrote:
> On 2010-12-08 16:11, Satoru Takeuchi wrote:
> > Hi Jens,
> > 
> > (2010/12/08 17:06), Jens Axboe wrote:
> >>>>> I hit on another approach. Although it doesn'tprevent any merge as Linus
> >>>>> preferred, it can fix the problem anyway. In this idea, in_flight is
> >>>>> incremented and decremented for the partition which the request belonged
> >>>>> to in its creation. It has the following merits.
> >>>
> >>> Revert is already finished. 2.6.37-rc-5 and latest stable kernel doesn't
> >>> contain Yasuaki's former logic.
> >>>
> >>> https://lkml.org/lkml/2010/10/24/118
> >>
> >> Yes I know, that is why I said:
> >>
> >>>> I really would prefer if we fixed up the patchset we ended up reverting..
> >>>> At least that had a purpose with growing struct request, since we saved
> >>>> on doing the partition lookups.
> >>
> >> That I prefer we fix that code up, since I think it's the best solution
> >> to the problem.
> >>
> > 
> > I already postedit.
> > 
> > https://lkml.org/lkml/2010/12/8/12
> > 
> > I think it is OK without mail subject :-)
> 
> No, that's not it at all. What I mean (and what was reverted) was
> caching the partition lookup, and using that for the stats. The problem
> with that approach turned out to be the elevator queiscing logic not
> being fully correct. One easier way to fix that would be to reference
> count the part stats, instead of having to drain the queue.

Taking reference to hd_struct and storing it in rq, will definitely save
us 1 lookup while doing accounting on completion path. It does not save
on rq size though.

IIUC, current patch does not increase the number of existing lookups. So 
current situation does not deteriorate with the patch.

But storing a reference in rq and avoiding 1 lookup in completion path
definitely sounds better.

Thanks
Vivek
