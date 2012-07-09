Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285Ab2GILGF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 07:06:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55706 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752910Ab2GILGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 07:06:03 -0400
Date: Mon, 9 Jul 2012 13:05:29 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: Ulrich Drepper <drepper@gmail.com>, Namhyung Kim <namhyung@gmail.com>,
        acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu,
        paulus@samba.org, cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, andi@firstfloor.org
Subject: Re: [PATCHv3 0/3] perf tool: Add new event group management
Message-ID: <20120709110528.GA965@krava.redhat.com>
References: <1340960907-3725-1-git-send-email-jolsa@redhat.com>
 <87fw9blyhj.fsf@sejong.aot.lge.com>
 <20120702101518.GC967@krava.redhat.com>
 <1341234662.1476.13.camel@leonhard>
 <20120702133341.GD967@krava.redhat.com>
 <CABPqkBTKNuwJXY7jRa+Zt8rmFftZUeJiYKEsKJeRiLdoHN3KWQ@mail.gmail.com>
 <CAOPLpQfWtyRHYT1ZfcdmshYoapBgF=FO7yFacYe8pyL0MBeebA@mail.gmail.com>
 <CABPqkBTTZaCVTtwJZbjXGwAihKAW_PMFK0+TZUTvbOn4pnfzvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBTTZaCVTtwJZbjXGwAihKAW_PMFK0+TZUTvbOn4pnfzvA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2012 at 03:42:54AM +0200, Stephane Eranian wrote:
> On Fri, Jul 6, 2012 at 3:32 AM, Ulrich Drepper <drepper@gmail.com> wrote:
> > On Thu, Jul 5, 2012 at 12:15 PM, Stephane Eranian <eranian@google.com> wrote:
> >> I don't understand why you actually need the :2 suffix. There can
> >> only be one leader. So assume it is the first one. Users have to
> >> know the first one is the leader which seems like a natural thing
> >> to do for me. It would make you syntax less ugly than it already
> >> is.
> >
> > In a blue sky world I would have done this.  In fact, this is what I
> > tried before reading the sources to find out there is no group support
> > so far.  But given that multiple -e options already have a meaning I
> > would be hesitant to change this.
> 
> That's why I said you activate grouping via -e only when you have
> the --group-events or --group-reads option in front. That would
> not change the meaning of the multiple -e when none of those
> group options are specified.

I discussed this with peter..

<peterz> the {} thing allows: 1) multiple groups in a single -e, 2) group attributes 

as for the leader sampling, we can have the first event to become the leader
by default (omit the leader index modifier) and enable the leader sampling by
another modifier:

<peterz> right, just make it a single 'l' (el not one) to indicate 'leader' sampling


jirka
